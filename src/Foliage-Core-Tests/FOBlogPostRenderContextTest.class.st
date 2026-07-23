Class {
	#name : #FOBlogPostRenderContextTest,
	#superclass : #TestCase,
	#instVars : [
		'blog'
	],
	#category : #'Foliage-Core-Tests'
}

{ #category : #running }
FOBlogPostRenderContextTest >> setUp [
	super setUp.
	blog := FOBlog new title: 'My Blog'; yourself.
	FOWebSite new root at: #blog put: blog
]

{ #category : #private }
FOBlogPostRenderContextTest >> makePostTitled: aTitle publishDate: aDateString series: aSlug [
	| post |
	post := FOFoliagePage new
		meta: (Dictionary new
			at: #title put: aTitle;
			at: #publishDate put: aDateString;
			yourself);
		document: (FOMarkdownParser parse: aTitle, ' text.');
		yourself.
	aSlug ifNotNil: [ post meta at: #series put: aSlug ].
	^ post
]

{ #category : #private }
FOBlogPostRenderContextTest >> contextFor: aFOBlogPost [
	^ FOBlogPostRenderContext new page: aFOBlogPost; yourself
]

{ #category : #tests }
FOBlogPostRenderContextTest >> testHasSeriesIsFalseWhenPostHasNoSeries [
	blog at: #solo put: (self makePostTitled: 'Solo' publishDate: '2020-01-01' series: nil).
	self deny: (self contextFor: (blog / #solo)) hasSeries
]

{ #category : #tests }
FOBlogPostRenderContextTest >> testSeriesNavigationAndTitleForMiddlePart [
	| part1 part2 part3 context |
	blog at: #part1 put: (self makePostTitled: 'Part 1' publishDate: '2026-07-20' series: 'soil').
	blog at: #part2 put: (self makePostTitled: 'Part 2' publishDate: '2026-07-21' series: 'soil').
	blog at: #part3 put: (self makePostTitled: 'Part 3' publishDate: '2026-07-22' series: 'soil').
	part1 := blog / #part1.
	part2 := blog / #part2.
	part3 := blog / #part3.
	context := self contextFor: part2.
	self assert: context hasSeries.
	self assert: context seriesTitle equals: 'Soil'.
	self assert: context seriesPartNumber equals: 2.
	self assert: context seriesPartCount equals: 3.
	self assert: context seriesOverviewPath equals: '/blog/series/soil.html'.
	self assert: context seriesPreviousPost equals: part1.
	self assert: context seriesNextPost equals: part3
]

{ #category : #tests }
FOBlogPostRenderContextTest >> testSeriesNavigationHasNoPreviousOnFirstPartOrNextOnLastPart [
	| part1 part2 |
	blog at: #part1 put: (self makePostTitled: 'Part 1' publishDate: '2026-07-20' series: 'soil').
	blog at: #part2 put: (self makePostTitled: 'Part 2' publishDate: '2026-07-21' series: 'soil').
	part1 := blog / #part1.
	part2 := blog / #part2.
	self assert: (self contextFor: part1) seriesPreviousPost isNil.
	self assert: (self contextFor: part2) seriesNextPost isNil
]
