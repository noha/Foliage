Class {
	#name : #FOSeriesIndexBuilderTest,
	#superclass : #TestCase,
	#instVars : [
		'tempDir',
		'site',
		'blog'
	],
	#category : #'Foliage-Core-Tests'
}

{ #category : #running }
FOSeriesIndexBuilderTest >> setUp [
	super setUp.
	tempDir := FileLocator temp / ('fo-series-index-test-', UUID new asString36).
	tempDir ensureCreateDirectory.
	(tempDir / 'templates') ensureCreateDirectory.
	(tempDir / 'templates' / 'blog') writeStreamDo: [ :s |
		s nextPutAll: '<html><title>{{page.title}}</title>{{{ body }}}</html>' ].
	(tempDir / 'templates' / 'blog-post-abstract') writeStreamDo: [ :s |
		s nextPutAll: '<article>{{abstract}}</article>' ].
	(tempDir / 'templates' / 'blog-post') writeStreamDo: [ :s |
		s nextPutAll: '<html><title>{{page.title}}</title>{{{ body }}}</html>' ].
	(tempDir / 'templates' / 'series-abstract') writeStreamDo: [ :s |
		s nextPutAll: '<section><a href="{{pathString}}">{{title}}</a> ({{partCount}} parts): {{abstract}}</section>' ].
	site := FOWebSite new
		targetPath: (tempDir / 'docs');
		templatePath: (tempDir / 'templates');
		yourself.
	blog := FOBlog new title: 'My Blog'; yourself.
	site root at: #blog put: blog
]

{ #category : #running }
FOSeriesIndexBuilderTest >> tearDown [
	tempDir ifNotNil: [ tempDir exists ifTrue: [ tempDir deleteAll ] ].
	super tearDown
]

{ #category : #private }
FOSeriesIndexBuilderTest >> makePostTitled: aTitle publishDate: aDateString series: aSlug [
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
FOSeriesIndexBuilderTest >> testSeriesRenderAbstractUsesTheSeriesAbstractTemplate [
	| aSeries |
	blog at: #part1 put: (self makePostTitled: 'Part 1' publishDate: '2026-07-20' series: 'soil').
	blog at: #part2 put: (self makePostTitled: 'Part 2' publishDate: '2026-07-21' series: 'soil').
	aSeries := blog series detect: [ :s | s slug = 'soil' ].
	self assert: aSeries renderAbstract equals:
		'<section><a href="/blog/series/soil.html">Soil</a> (2 parts): Part 1 text.</section>'
]

{ #category : #tests }
FOSeriesIndexBuilderTest >> testAbstractPrefersHandWrittenDataFileOverAutoDerivedOne [
	| aSeries |
	site dataPath: (tempDir / 'data').
	(tempDir / 'data' / 'series') ensureCreateDirectory.
	(tempDir / 'data' / 'series' / 'soil.md') writeStreamDo: [ :s |
		s nextPutAll: 'A hand-written description of the whole series.' ].
	blog at: #part1 put: (self makePostTitled: 'Part 1' publishDate: '2026-07-20' series: 'soil').
	aSeries := blog series detect: [ :s | s slug = 'soil' ].
	self assert: aSeries abstract equals: 'A hand-written description of the whole series.'
]

{ #category : #tests }
FOSeriesIndexBuilderTest >> testAbstractFallsBackToFirstPostWhenNoDataFileExists [
	| aSeries |
	site dataPath: (tempDir / 'data').
	blog at: #part1 put: (self makePostTitled: 'Part 1' publishDate: '2026-07-20' series: 'soil').
	aSeries := blog series detect: [ :s | s slug = 'soil' ].
	self assert: aSeries abstract equals: 'Part 1 text.'
]

{ #category : #tests }
FOSeriesIndexBuilderTest >> testBuildPageListsEverySeriesNewestActiveFirst [
	| builder page stream |
	blog at: #soilOld put: (self makePostTitled: 'Soil old' publishDate: '2020-01-01' series: 'soil').
	blog at: #byobNew put: (self makePostTitled: 'Byob new' publishDate: '2026-07-01' series: 'byob').
	builder := FOSeriesIndexBuilder new blog: blog; yourself.
	page := builder buildPage.
	self assert: page title equals: 'Series'.
	stream := WriteStream on: String new.
	page renderOn: stream.
	self assert: stream contents equals:
		'<section><a href="/blog/series/byob.html">Byob</a> (1 parts): Byob new text.</section>',
		'<section><a href="/blog/series/soil.html">Soil</a> (1 parts): Soil old text.</section>'
]
