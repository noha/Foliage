Class {
	#name : #FOTagOverviewBuilderTest,
	#superclass : #TestCase,
	#instVars : [
		'tempDir',
		'site',
		'blog'
	],
	#category : #'Foliage-Core-Tests'
}

{ #category : #running }
FOTagOverviewBuilderTest >> setUp [
	super setUp.
	tempDir := FileLocator temp / ('fo-tag-overview-test-', UUID new asString36).
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
FOTagOverviewBuilderTest >> tearDown [
	tempDir ifNotNil: [ tempDir exists ifTrue: [ tempDir deleteAll ] ].
	super tearDown
]

{ #category : #private }
FOTagOverviewBuilderTest >> makePostTitled: aTitle publishDate: aDateString tags: aTagsArray [
	| post |
	post := FOFoliagePage new
		meta: (Dictionary new
			at: #title put: aTitle;
			at: #publishDate put: aDateString;
			yourself);
		document: (FOMarkdownParser parse: aTitle, ' text.');
		yourself.
	post meta at: #tags put: aTagsArray.
	^ post
]

{ #category : #tests }
FOTagOverviewBuilderTest >> testBuildPagesContainsOnlyThatTagAbstractsNewestFirst [
	| builder aTag pages stream |
	blog at: #part1 put: (self makePostTitled: 'Part 1' publishDate: '2026-07-20' tags: #('soil')).
	blog at: #unrelated put: (self makePostTitled: 'Unrelated' publishDate: '2026-07-21' tags: #('other')).
	blog at: #part2 put: (self makePostTitled: 'Part 2' publishDate: '2026-07-22' tags: #('soil')).
	aTag := blog tags detect: [ :t | t slug = 'soil' ].
	builder := FOTagOverviewBuilder new blog: blog; tag: aTag; yourself.
	pages := builder buildPages.
	self assert: pages size equals: 1.
	self assert: pages first title equals: 'Soil'.
	stream := WriteStream on: String new.
	pages first renderOn: stream.
	self assert: stream contents equals:
		'<article>Part 2 text.</article><article>Part 1 text.</article>'
]

{ #category : #tests }
FOTagOverviewBuilderTest >> testBuildPageShowsHandWrittenAbstractAsIntroOnPageOneOnly [
	| builder aTag pages stream |
	site dataPath: (tempDir / 'data').
	(tempDir / 'data' / 'tags') ensureCreateDirectory.
	(tempDir / 'data' / 'tags' / 'soil.md') writeStreamDo: [ :s |
		s nextPutAll: 'A hand-written intro.' ].
	blog at: #part1 put: (self makePostTitled: 'Part 1' publishDate: '2026-07-20' tags: #('soil')).
	blog at: #part2 put: (self makePostTitled: 'Part 2' publishDate: '2026-07-21' tags: #('soil')).
	aTag := blog tags detect: [ :t | t slug = 'soil' ].
	builder := FOTagOverviewBuilder new blog: blog; tag: aTag; pageSize: 1; yourself.
	pages := builder buildPages.
	self assert: pages size equals: 2.
	stream := WriteStream on: String new.
	pages first renderOn: stream.
	self assert: (stream contents includesSubstring:
		'<p>A hand-written intro.</p><article>Part 2 text.</article>').
	self assert: (pages first htmlString includesSubstring: 'href="/blog/tags/soil/page2.html">older</a>').
	self deny: (pages second htmlString includesSubstring: 'hand-written intro')
]

{ #category : #tests }
FOTagOverviewBuilderTest >> testBuildPageHasNoIntroWhenNoDataFileExists [
	| builder aTag pages stream |
	blog at: #part1 put: (self makePostTitled: 'Part 1' publishDate: '2026-07-20' tags: #('soil')).
	aTag := blog tags detect: [ :t | t slug = 'soil' ].
	builder := FOTagOverviewBuilder new blog: blog; tag: aTag; yourself.
	pages := builder buildPages.
	stream := WriteStream on: String new.
	pages first renderOn: stream.
	self assert: stream contents equals: '<article>Part 1 text.</article>'
]

{ #category : #tests }
FOTagOverviewBuilderTest >> testFewerPostsThanPageSizeYieldsOnePageWithNoNavigationLinks [
	| builder aTag pages |
	blog at: #part1 put: (self makePostTitled: 'Part 1' publishDate: '2026-07-20' tags: #('soil')).
	aTag := blog tags detect: [ :t | t slug = 'soil' ].
	builder := FOTagOverviewBuilder new blog: blog; tag: aTag; yourself.
	pages := builder buildPages.
	self assert: pages size equals: 1.
	self assert: (pages first htmlString includesSubstring: 'older') not.
	self assert: (pages first htmlString includesSubstring: 'newer') not
]

{ #category : #tests }
FOTagOverviewBuilderTest >> testPaginationSplitsPostsAcrossPagesNewestFirstUnderTagPath [
	"5 posts tagged 'soil', page size 2 -> [mar,feb] [jan,dec] [nov], same
	shape as FOBlogOverviewBuilderTest's pagination test but links are rooted
	under /blog/tags/soil/ instead of /blog/."
	| builder aTag pages |
	blog at: #jan put: (self makePostTitled: 'Jan' publishDate: '2020-01-01' tags: #('soil')).
	blog at: #feb put: (self makePostTitled: 'Feb' publishDate: '2020-02-01' tags: #('soil')).
	blog at: #mar put: (self makePostTitled: 'Mar' publishDate: '2020-03-01' tags: #('soil')).
	blog at: #dec put: (self makePostTitled: 'Dec' publishDate: '2019-12-01' tags: #('soil')).
	blog at: #nov put: (self makePostTitled: 'Nov' publishDate: '2019-11-01' tags: #('soil')).
	aTag := blog tags detect: [ :t | t slug = 'soil' ].
	builder := FOTagOverviewBuilder new blog: blog; tag: aTag; pageSize: 2; yourself.
	pages := builder buildPages.
	self assert: pages size equals: 3.

	self assert: (pages first htmlString includesSubstring: '<article>Mar text.</article><article>Feb text.</article>').
	self assert: (pages first htmlString includesSubstring: 'href="/blog/tags/soil/page2.html">older</a>').
	self assert: (pages first htmlString includesSubstring: 'newer') not.

	self assert: (pages second htmlString includesSubstring: '<article>Jan text.</article><article>Dec text.</article>').
	self assert: (pages second htmlString includesSubstring: 'href="/blog/tags/soil/index.html">newer</a>').
	self assert: (pages second htmlString includesSubstring: 'href="/blog/tags/soil/page3.html">older</a>').

	self assert: (pages third htmlString includesSubstring: '<article>Nov text.</article>').
	self assert: (pages third htmlString includesSubstring: 'href="/blog/tags/soil/page2.html">newer</a>').
	self assert: (pages third htmlString includesSubstring: 'older') not
]
