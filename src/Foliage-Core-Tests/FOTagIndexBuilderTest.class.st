Class {
	#name : #FOTagIndexBuilderTest,
	#superclass : #TestCase,
	#instVars : [
		'tempDir',
		'site',
		'blog'
	],
	#category : #'Foliage-Core-Tests'
}

{ #category : #running }
FOTagIndexBuilderTest >> setUp [
	super setUp.
	tempDir := FileLocator temp / ('fo-tag-index-test-', UUID new asString36).
	tempDir ensureCreateDirectory.
	(tempDir / 'templates') ensureCreateDirectory.
	(tempDir / 'templates' / 'blog') writeStreamDo: [ :s |
		s nextPutAll: '<html><title>{{page.title}}</title>{{{ body }}}</html>' ].
	(tempDir / 'templates' / 'blog-post-abstract') writeStreamDo: [ :s |
		s nextPutAll: '<article>{{abstract}}</article>' ].
	(tempDir / 'templates' / 'blog-post') writeStreamDo: [ :s |
		s nextPutAll: '<html><title>{{page.title}}</title>{{{ body }}}</html>' ].
	(tempDir / 'templates' / 'tag-abstract') writeStreamDo: [ :s |
		s nextPutAll: '<section><a href="{{pathString}}">{{title}}</a> ({{postCount}} posts): {{abstract}}</section>' ].
	site := FOWebSite new
		outputPath: (tempDir / 'docs');
		templatePath: (tempDir / 'templates');
		yourself.
	blog := FOBlog new title: 'My Blog'; yourself.
	site root at: #blog put: blog
]

{ #category : #running }
FOTagIndexBuilderTest >> tearDown [
	tempDir ifNotNil: [ tempDir exists ifTrue: [ tempDir deleteAll ] ].
	super tearDown
]

{ #category : #private }
FOTagIndexBuilderTest >> makePostTitled: aTitle publishDate: aDateString tags: aTagsArray [
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
FOTagIndexBuilderTest >> testTagRenderAbstractUsesTheTagAbstractTemplate [
	| aTag |
	blog at: #part1 put: (self makePostTitled: 'Part 1' publishDate: '2026-07-20' tags: #('soil')).
	blog at: #part2 put: (self makePostTitled: 'Part 2' publishDate: '2026-07-21' tags: #('soil')).
	aTag := blog tags detect: [ :t | t slug = 'soil' ].
	self assert: aTag renderAbstract equals:
		'<section><a href="/blog/tags/soil/index.html">Soil</a> (2 posts): Part 2 text.</section>'
]

{ #category : #tests }
FOTagIndexBuilderTest >> testAbstractPrefersHandWrittenDataFileOverAutoDerivedOne [
	| aTag |
	site dataPath: (tempDir / 'data').
	(tempDir / 'data' / 'tags') ensureCreateDirectory.
	(tempDir / 'data' / 'tags' / 'soil.md') writeStreamDo: [ :s |
		s nextPutAll: 'A hand-written description of the whole tag.' ].
	blog at: #part1 put: (self makePostTitled: 'Part 1' publishDate: '2026-07-20' tags: #('soil')).
	aTag := blog tags detect: [ :t | t slug = 'soil' ].
	self assert: aTag abstract equals: 'A hand-written description of the whole tag.'
]

{ #category : #tests }
FOTagIndexBuilderTest >> testAbstractFallsBackToNewestPostWhenNoDataFileExists [
	"Unlike FOSeries (falls back to the oldest/part-1 post), a tag has no
	'part 1' - the newest post is the most sensible representative excerpt."
	| aTag |
	site dataPath: (tempDir / 'data').
	blog at: #older put: (self makePostTitled: 'Older' publishDate: '2026-07-20' tags: #('soil')).
	blog at: #newer put: (self makePostTitled: 'Newer' publishDate: '2026-07-21' tags: #('soil')).
	aTag := blog tags detect: [ :t | t slug = 'soil' ].
	self assert: aTag abstract equals: 'Newer text.'
]

{ #category : #tests }
FOTagIndexBuilderTest >> testBuildPageListsEveryTagNewestActiveFirst [
	| builder page stream |
	blog at: #soilOld put: (self makePostTitled: 'Soil old' publishDate: '2020-01-01' tags: #('soil')).
	blog at: #byobNew put: (self makePostTitled: 'Byob new' publishDate: '2026-07-01' tags: #('byob')).
	builder := FOTagIndexBuilder new blog: blog; yourself.
	page := builder buildPage.
	self assert: page title equals: 'Tags'.
	stream := WriteStream on: String new.
	page renderOn: stream.
	self assert: stream contents equals:
		'<section><a href="/blog/tags/byob/index.html">Byob</a> (1 posts): Byob new text.</section>',
		'<section><a href="/blog/tags/soil/index.html">Soil</a> (1 posts): Soil old text.</section>'
]

{ #category : #tests }
FOTagIndexBuilderTest >> testBuildPageListsTagsSharedAcrossMultiplePosts [
	| builder page stream |
	blog at: #a put: (self makePostTitled: 'Post A' publishDate: '2020-01-01' tags: #('soil' 'database')).
	blog at: #b put: (self makePostTitled: 'Post B' publishDate: '2020-02-01' tags: #('soil')).
	builder := FOTagIndexBuilder new blog: blog; yourself.
	page := builder buildPage.
	stream := WriteStream on: String new.
	page renderOn: stream.
	self assert: (stream contents includesSubstring: 'href="/blog/tags/soil/index.html">Soil</a> (2 posts)').
	self assert: (stream contents includesSubstring: 'href="/blog/tags/database/index.html">Database</a> (1 posts)')
]
