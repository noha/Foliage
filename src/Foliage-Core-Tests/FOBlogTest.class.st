Class {
	#name : #FOBlogTest,
	#superclass : #TestCase,
	#instVars : [
		'blog'
	],
	#category : #'Foliage-Core-Tests'
}

{ #category : #private }
FOBlogTest >> makePostTitled: aTitle publishDate: aDateString [
	^ FOFoliagePage new
		meta: (Dictionary new
			at: #title put: aTitle;
			at: #publishDate put: aDateString;
			yourself);
		document: (FOMarkdownParser parse: 'Text about ', aTitle, '.');
		yourself
]

{ #category : #private }
FOBlogTest >> makePostTitled: aTitle publishDate: aDateString series: aSlug [
	| post |
	post := self makePostTitled: aTitle publishDate: aDateString.
	post meta at: #series put: aSlug.
	^ post
]

{ #category : #running }
FOBlogTest >> setUp [
	super setUp.
	blog := FOBlog new
]

{ #category : #tests }
FOBlogTest >> testInsertingAFoliagePageAdaptsItToABlogPost [
	| inserted |
	blog at: #'post-one' put: (self makePostTitled: 'One' publishDate: '2020-01-01').
	inserted := blog / #'post-one'.
	self assert: (inserted isKindOf: FOBlogPost).
	self assert: inserted title equals: 'One'.
	self assert: inserted isPost
]

{ #category : #tests }
FOBlogTest >> testNonPageResourcesAreNotAdapted [
	| image |
	image := FOWebImage new.
	blog at: #'logo.png' put: image.
	self assert: (blog / #'logo.png') class equals: FOWebImage
]

{ #category : #tests }
FOBlogTest >> testPostsAndPublishedPosts [
	blog at: #'post-one' put: (self makePostTitled: 'One' publishDate: '2020-01-01').
	blog at: #'post-two' put: (self makePostTitled: 'Two' publishDate: '').
	blog at: #'not-a-post' put: FOWebImage new.
	self assert: blog posts size equals: 2.
	self assert: blog publishedPosts size equals: 1.
	self assert: blog publishedPosts first title equals: 'One'
]

{ #category : #tests }
FOBlogTest >> testSortedByPublishDateAndNextPreviousPost [
	| jan feb mar sorted |
	blog at: #jan put: (self makePostTitled: 'Jan' publishDate: '2020-01-01').
	blog at: #feb put: (self makePostTitled: 'Feb' publishDate: '2020-02-01').
	blog at: #mar put: (self makePostTitled: 'Mar' publishDate: '2020-03-01').
	jan := blog / #jan.
	feb := blog / #feb.
	mar := blog / #mar.
	sorted := blog sortedByPublishDate.
	self assert: (sorted collect: #title) asArray equals: #('Jan' 'Feb' 'Mar').
	self assert: (blog postAfter: jan) equals: feb.
	self assert: (blog postAfter: mar) isNil.
	self assert: (blog postBefore: feb) equals: jan.
	self assert: (blog postBefore: jan) isNil
]

{ #category : #tests }
FOBlogTest >> testDefaultLayoutAndTitle [
	self assert: blog layout equals: 'blog'.
	self assert: blog title equals: 'Untitled'.
	blog title: 'My Blog'.
	self assert: blog title equals: 'My Blog'
]

{ #category : #tests }
FOBlogTest >> testBlogPathsCreatesAFOBlogDuringImport [
	"Exercises the mechanism wired up (but not yet testable) back when
	FOWebSite>>blogPaths and FOWebFolder>>newChildNamed: were added - FOBlog
	didn't exist yet at that point."
	| site resolved |
	site := FOTestBlogWebsite new.
	resolved := site resolvePath: (RelativePath from: 'blog').
	self assert: (resolved isKindOf: FOBlog).
	self assert: (site resolvePath: (RelativePath from: 'other')) class equals: FOWebFolder
]

{ #category : #tests }
FOBlogTest >> testPostsInSeriesReturnsOnlyMatchingPostsOldestFirst [
	"Reading order (ascending), not the blog's own newest-first browsing
	order - and inserted out of date order to prove it's actually sorted,
	not just insertion order."
	blog at: #part2 put: (self makePostTitled: 'Part 2' publishDate: '2026-07-22' series: 'soil').
	blog at: #unrelated put: (self makePostTitled: 'Unrelated' publishDate: '2026-07-21').
	blog at: #part1 put: (self makePostTitled: 'Part 1' publishDate: '2026-07-20' series: 'soil').
	self assert: ((blog postsInSeries: 'soil') collect: #title) asArray equals: #('Part 1' 'Part 2')
]

{ #category : #tests }
FOBlogTest >> testSeriesSlugsAndSeriesCollection [
	blog at: #a put: (self makePostTitled: 'Soil A' publishDate: '2026-07-20' series: 'soil').
	blog at: #b put: (self makePostTitled: 'Byob A' publishDate: '2023-01-07' series: 'byob').
	blog at: #c put: (self makePostTitled: 'No series' publishDate: '2020-01-01').
	self assert: blog seriesSlugs equals: #('soil' 'byob') asSet.
	self assert: (blog series collect: #slug) asArray equals: #('soil' 'byob').
	self assert: (blog series first title) equals: 'Soil'.
	self assert: (blog series first posts size) equals: 1
]

{ #category : #tests }
FOBlogTest >> testSeriesAreSortedByTheirMostRecentPostDescending [
	"'byob' has an older first post but a NEWER last post than 'soil' -
	proves the sort looks at each series' most recent (last) post, not its
	first one or its slug."
	blog at: #byobOld put: (self makePostTitled: 'Byob old' publishDate: '2020-01-01' series: 'byob').
	blog at: #byobNew put: (self makePostTitled: 'Byob new' publishDate: '2026-07-01' series: 'byob').
	blog at: #soil put: (self makePostTitled: 'Soil only' publishDate: '2023-06-01' series: 'soil').
	self assert: (blog series collect: #slug) asArray equals: #('byob' 'soil')
]

{ #category : #tests }
FOBlogTest >> testSeriesPostAfterAndBeforeIgnoreUnrelatedPosts [
	| part1 part2 |
	blog at: #part1 put: (self makePostTitled: 'Part 1' publishDate: '2026-07-20' series: 'soil').
	blog at: #unrelated put: (self makePostTitled: 'Unrelated' publishDate: '2026-07-21').
	blog at: #part2 put: (self makePostTitled: 'Part 2' publishDate: '2026-07-22' series: 'soil').
	part1 := blog / #part1.
	part2 := blog / #part2.
	self assert: (blog seriesPostAfter: part1) equals: part2.
	self assert: (blog seriesPostBefore: part2) equals: part1.
	self assert: (blog seriesPostAfter: part2) isNil.
	self assert: (blog seriesPostBefore: part1) isNil
]
