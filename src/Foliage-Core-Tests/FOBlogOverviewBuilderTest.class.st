Class {
	#name : #FOBlogOverviewBuilderTest,
	#superclass : #TestCase,
	#instVars : [
		'tempDir',
		'site',
		'blog'
	],
	#category : #'Foliage-Core-Tests'
}

{ #category : #running }
FOBlogOverviewBuilderTest >> setUp [
	super setUp.
	tempDir := FileLocator temp / ('fo-blog-overview-test-', UUID new asString36).
	tempDir ensureCreateDirectory.
	(tempDir / 'templates') ensureCreateDirectory.
	(tempDir / 'templates' / 'blog') writeStreamDo: [ :s |
		s nextPutAll: '<html><title>{{page.title}}</title>{{{ body }}}</html>' ].
	(tempDir / 'templates' / 'blog-post-abstract') writeStreamDo: [ :s |
		s nextPutAll: '<article>{{abstract}}</article>' ].
	(tempDir / 'templates' / 'blog-post') writeStreamDo: [ :s |
		s nextPutAll: '<html><title>{{page.title}}</title>{{{ body }}}</html>' ].
	site := FOWebSite new
		targetPath: (tempDir / 'docs');
		templatePath: (tempDir / 'templates');
		yourself.
	blog := FOBlog new title: 'My Blog'; yourself.
	site root at: #blog put: blog
]

{ #category : #running }
FOBlogOverviewBuilderTest >> tearDown [
	tempDir ifNotNil: [ tempDir exists ifTrue: [ tempDir deleteAll ] ].
	super tearDown
]

{ #category : #private }
FOBlogOverviewBuilderTest >> makePostTitled: aTitle publishDate: aDateString text: aText [
	^ FOFoliagePage new
		meta: (Dictionary new
			at: #title put: aTitle;
			at: #publishDate put: aDateString;
			yourself);
		document: (FOMarkdownParser parse: aText);
		yourself
]

{ #category : #tests }
FOBlogOverviewBuilderTest >> testOverviewPageContainsAllPublishedAbstractsInDescendingOrder [
	"Checks the body content specifically (renderOn:, same as FOFoliagePageTest
	does for a normal page) - bodyHtml only supplies the body slot, the outer
	template still wraps it (see testOverviewPagePublishesCorrectly for that)."
	| overview stream |
	blog at: #jan put: (self makePostTitled: 'Jan post' publishDate: '2020-01-01' text: 'January text.').
	blog at: #feb put: (self makePostTitled: 'Feb post' publishDate: '2020-02-01' text: 'February text.').
	blog at: #draft put: (self makePostTitled: 'Draft' publishDate: '' text: 'Not published.').
	overview := blog overviewPage.
	self assert: (overview isKindOf: FOFoliagePage).
	self assert: overview title equals: 'My Blog'.
	stream := WriteStream on: String new.
	overview renderOn: stream.
	self assert: stream contents equals:
		'<article>February text.</article><article>January text.</article>'
]

{ #category : #tests }
FOBlogOverviewBuilderTest >> testOverviewPagePublishesCorrectly [
	| overview publishedFile |
	blog at: #jan put: (self makePostTitled: 'Jan post' publishDate: '2020-01-01' text: 'January text.').
	overview := blog overviewPage.
	site root at: #'index.html' put: overview.
	FOPublishVisitor new start: site.
	publishedFile := tempDir / 'docs' / 'index.html'.
	self assert: publishedFile exists.
	self assert: publishedFile contents equals: '<html><title>My Blog</title><article>January text.</article></html>'
]
