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
		outputPath: (tempDir / 'docs');
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

{ #category : #tests }
FOBlogOverviewBuilderTest >> testFewerPostsThanPageSizeYieldsOnePageWithNoNavigationLinks [
	blog at: #jan put: (self makePostTitled: 'Jan post' publishDate: '2020-01-01' text: 'January text.').
	blog at: #feb put: (self makePostTitled: 'Feb post' publishDate: '2020-02-01' text: 'February text.').
	self assert: blog overviewPages size equals: 1.
	self assert: (blog overviewPage htmlString includesSubstring: 'older') not.
	self assert: (blog overviewPage htmlString includesSubstring: 'newer') not
]

{ #category : #tests }
FOBlogOverviewBuilderTest >> testPaginationSplitsPostsAcrossPagesNewestFirst [
	"5 posts, page size 2 (set below default 10 so the test doesn't need 11
	posts to exercise pagination) -> pages of [mar,feb] [jan,dec] [nov].
	First page: only 'older' (nothing is newer than the newest page). Last
	page: only 'newer' (nothing is older than the oldest page). Middle
	page: both."
	| builder pages |
	blog at: #jan put: (self makePostTitled: 'Jan post' publishDate: '2020-01-01' text: 'Jan text.').
	blog at: #feb put: (self makePostTitled: 'Feb post' publishDate: '2020-02-01' text: 'Feb text.').
	blog at: #mar put: (self makePostTitled: 'Mar post' publishDate: '2020-03-01' text: 'Mar text.').
	blog at: #dec put: (self makePostTitled: 'Dec post' publishDate: '2019-12-01' text: 'Dec text.').
	blog at: #nov put: (self makePostTitled: 'Nov post' publishDate: '2019-11-01' text: 'Nov text.').
	builder := FOBlogOverviewBuilder new blog: blog; pageSize: 2; yourself.
	pages := builder buildPages.
	self assert: pages size equals: 3.

	self assert: (pages first htmlString includesSubstring: '<article>Mar text.</article><article>Feb text.</article>').
	self assert: (pages first htmlString includesSubstring: 'href="/blog/page2.html">older</a>').
	self assert: (pages first htmlString includesSubstring: 'newer') not.

	self assert: (pages second htmlString includesSubstring: '<article>Jan text.</article><article>Dec text.</article>').
	self assert: (pages second htmlString includesSubstring: 'href="/blog/index.html">newer</a>').
	self assert: (pages second htmlString includesSubstring: 'href="/blog/page3.html">older</a>').

	self assert: (pages third htmlString includesSubstring: '<article>Nov text.</article>').
	self assert: (pages third htmlString includesSubstring: 'href="/blog/page2.html">newer</a>').
	self assert: (pages third htmlString includesSubstring: 'older') not
]

{ #category : #tests }
FOBlogOverviewBuilderTest >> testPageFilenames [
	self assert: (FOBlogOverviewBuilder pageFilenameFor: 1) equals: #'index.html'.
	self assert: (FOBlogOverviewBuilder pageFilenameFor: 2) equals: #'page2.html'.
	self assert: (FOBlogOverviewBuilder pageFilenameFor: 3) equals: #'page3.html'
]
