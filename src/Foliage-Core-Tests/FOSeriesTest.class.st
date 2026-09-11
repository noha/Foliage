Class {
	#name : #FOSeriesTest,
	#superclass : #TestCase,
	#instVars : [
		'tempDir',
		'site',
		'blog'
	],
	#category : #'Foliage-Core-Tests'
}

{ #category : #running }
FOSeriesTest >> setUp [
	super setUp.
	tempDir := FileLocator temp / ('fo-series-test-', UUID new asString36).
	tempDir ensureCreateDirectory.
	site := FOWebSite new
		outputPath: (tempDir / 'docs');
		dataPath: (tempDir / 'data');
		yourself.
	blog := FOBlog new title: 'My Blog'; yourself.
	site root at: #blog put: blog.
	(tempDir / 'data' / 'series') ensureCreateDirectory
]

{ #category : #running }
FOSeriesTest >> tearDown [
	tempDir ifNotNil: [ tempDir exists ifTrue: [ tempDir deleteAll ] ].
	super tearDown
]

{ #category : #private }
FOSeriesTest >> makePostTitled: aTitle publishDate: aDateString series: aSlug [
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
FOSeriesTest >> testTitleFromSlugCapitalizesEachHyphenatedWord [
	self assert: (FOSeries titleFromSlug: 'soil') equals: 'Soil'.
	self assert: (FOSeries titleFromSlug: 'byob-database') equals: 'Byob Database'
]

{ #category : #tests }
FOSeriesTest >> testTitleFromSlugHandlesSingleLetterWords [
	self assert: (FOSeries titleFromSlug: 'a-b') equals: 'A B'
]

{ #category : #tests }
FOSeriesTest >> testTitleDelegatesToClassSideTitleFromSlug [
	| series |
	series := FOSeries new slug: 'soil'; yourself.
	self assert: series title equals: 'Soil'
]

{ #category : #tests }
FOSeriesTest >> testAbstractRendersRealHtmlNotFlattenedPlainText [
	"The old renderDataAbstract: used FOPlainTextVisitor and silently dropped
	links - abstract (and teaser) now go through FOHTMLRenderVisitor
	instead, so a link in the data file survives as a real <a href=...>."
	(tempDir / 'data' / 'series' / 'soil.md') writeStreamDo: [ :s |
		s nextPutAll: 'The [overview](https://example.com) text.' ].
	blog at: #part1 put: (self makePostTitled: 'Part 1' publishDate: '2026-07-20' series: 'soil').
	self assert: (blog seriesNamed: 'soil') abstract equals:
		'<p>The <a href="https://example.com">overview</a> text.</p>'
]

{ #category : #tests }
FOSeriesTest >> testTeaserFallsBackToAbstractWhenNoTeaserFileExists [
	(tempDir / 'data' / 'series' / 'soil.md') writeStreamDo: [ :s |
		s nextPutAll: 'The overview text.' ].
	blog at: #part1 put: (self makePostTitled: 'Part 1' publishDate: '2026-07-20' series: 'soil').
	self assert: (blog seriesNamed: 'soil') teaser equals: (blog seriesNamed: 'soil') abstract
]

{ #category : #tests }
FOSeriesTest >> testTeaserUsesItsOwnFileWhenPresent [
	(tempDir / 'data' / 'series' / 'soil.md') writeStreamDo: [ :s |
		s nextPutAll: 'The long overview text.' ].
	(tempDir / 'data' / 'series' / 'soil-teaser.md') writeStreamDo: [ :s |
		s nextPutAll: 'A short [teaser](https://example.com).' ].
	blog at: #part1 put: (self makePostTitled: 'Part 1' publishDate: '2026-07-20' series: 'soil').
	self assert: (blog seriesNamed: 'soil') teaser equals:
		'<p>A short <a href="https://example.com">teaser</a>.</p>'.
	self assert: (blog seriesNamed: 'soil') abstract equals: '<p>The long overview text.</p>'
]

{ #category : #tests }
FOSeriesTest >> testHasCustomTeaser [
	blog at: #part1 put: (self makePostTitled: 'Part 1' publishDate: '2026-07-20' series: 'soil').
	self deny: (blog seriesNamed: 'soil') hasCustomTeaser.
	(tempDir / 'data' / 'series' / 'soil-teaser.md') writeStreamDo: [ :s | s nextPutAll: 'Short.' ].
	self assert: (blog seriesNamed: 'soil') hasCustomTeaser
]
