Class {
	#name : #FOSeriesOverviewBuilderTest,
	#superclass : #TestCase,
	#instVars : [
		'tempDir',
		'site',
		'blog'
	],
	#category : #'Foliage-Core-Tests'
}

{ #category : #running }
FOSeriesOverviewBuilderTest >> setUp [
	super setUp.
	tempDir := FileLocator temp / ('fo-series-overview-test-', UUID new asString36).
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
FOSeriesOverviewBuilderTest >> tearDown [
	tempDir ifNotNil: [ tempDir exists ifTrue: [ tempDir deleteAll ] ].
	super tearDown
]

{ #category : #private }
FOSeriesOverviewBuilderTest >> makePostTitled: aTitle publishDate: aDateString series: aSlug [
	| post |
	post := FOFoliagePage new
		meta: (Dictionary new
			at: #title put: aTitle;
			at: #publishDate put: aDateString;
			yourself);
		document: (FOMarkdownParser parse: aTitle, ' text.');
		yourself.
	post meta at: #series put: aSlug.
	^ post
]

{ #category : #tests }
FOSeriesOverviewBuilderTest >> testBuildPageContainsOnlyThatSeriesAbstractsOldestFirst [
	| builder aSeries page stream |
	blog at: #part2 put: (self makePostTitled: 'Part 2' publishDate: '2026-07-22' series: 'soil').
	blog at: #unrelated put: (self makePostTitled: 'Unrelated' publishDate: '2026-07-21' series: 'other').
	blog at: #part1 put: (self makePostTitled: 'Part 1' publishDate: '2026-07-20' series: 'soil').
	aSeries := blog series detect: [ :s | s slug = 'soil' ].
	builder := FOSeriesOverviewBuilder new blog: blog; series: aSeries; yourself.
	page := builder buildPage.
	self assert: page title equals: 'Soil'.
	stream := WriteStream on: String new.
	page renderOn: stream.
	self assert: stream contents equals:
		'<article>Part 1 text.</article><article>Part 2 text.</article>'
]
