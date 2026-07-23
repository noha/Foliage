Class {
	#name : #FOBlog,
	#superclass : #FOWebFolder,
	#instVars : [
		'layout',
		'title'
	],
	#category : #'Foliage-Core-Blog'
}

{ #category : #visiting }
FOBlog >> acceptFOVisitor: aFOVisitor [
	^ aFOVisitor visitBlog: self
]

{ #category : #accessing }
FOBlog >> adaptIfPage: aResource [
	"Any Foliage page filed directly into a blog folder becomes a post - this
	replaces the old post-hoc convertToBlog bulk conversion (which ran once,
	after the fact, over an already-imported folder) with insertion-time
	adaptation, since blog folders now exist as FOBlog from the moment the
	import creates them (see FOWebFolder>>newChildNamed: / FOWebSite>>
	blogPaths)."
	^ (aResource isKindOf: FOFoliagePage)
		ifTrue: [ aResource asFOBlogPost ]
		ifFalse: [ aResource ]
]

{ #category : #accessing }
FOBlog >> at: key put: value [
	^ super at: key put: (self adaptIfPage: value)
]

{ #category : #accessing }
FOBlog >> defaultLayout [
	^ 'blog'
]

{ #category : #accessing }
FOBlog >> layout [
	^ layout ifNil: [ self defaultLayout ]
]

{ #category : #accessing }
FOBlog >> layout: aString [
	layout := aString
]

{ #category : #accessing }
FOBlog >> overviewPage [
	"The first page of the paginated overview - kept as a single-page
	accessor since most callers (and all callers before pagination existed)
	only need the blog's own index.html; see overviewPages for the full set."
	^ self overviewPages first
]

{ #category : #accessing }
FOBlog >> overviewPages [
	^ FOBlogOverviewBuilder new
		blog: self;
		buildPages
]

{ #category : #accessing }
FOBlog >> postAfter: aFOFoliagePage [
	| list index |
	list := self sortedByPublishDate.
	index := list indexOf: aFOFoliagePage.
	^ (index < list size)
		ifTrue: [ list at: index + 1 ]
		ifFalse: [ nil ]
]

{ #category : #accessing }
FOBlog >> postBefore: aFOFoliagePage [
	| list index |
	list := self sortedByPublishDate.
	index := list indexOf: aFOFoliagePage.
	^ (index > 1)
		ifTrue: [ list at: index - 1 ]
		ifFalse: [ nil ]
]

{ #category : #accessing }
FOBlog >> posts [
	^ items values select: #isPost
]

{ #category : #sorting }
FOBlog >> publishedPosts [
	^ self posts select: #isPublished
]

{ #category : #series }
FOBlog >> series [
	"One FOSeries per distinct 'series' slug found among published posts,
	newest-active-first: sorted by each series' most recent post (posts are
	stored reading-order-ascending, so that's simply the last one) -
	matches the blog overview's own newest-first convention, which is the
	common way other blogs/SSGs order a listing of multiple series."
	| unsorted |
	unsorted := self seriesSlugs asSortedCollection asArray collect: [ :slug |
		FOSeries new
			slug: slug;
			posts: (self postsInSeries: slug);
			blog: self;
			yourself ].
	^ unsorted asSortedCollection: [ :a :b | a posts last publishDate > b posts last publishDate ]
]

{ #category : #series }
FOBlog >> seriesSlugs [
	^ ((self publishedPosts select: #hasSeries) collect: #series) asSet
]

{ #category : #series }
FOBlog >> postsInSeries: aSlug [
	"Reading order (oldest/part-1 first) - a series is meant to be read in
	sequence, unlike the blog overview's newest-first browsing order."
	^ (self publishedPosts select: [ :post | post series = aSlug ]) sorted: #publishDate ascending
]

{ #category : #series }
FOBlog >> seriesPostAfter: aFOBlogPost [
	| list index |
	list := self postsInSeries: aFOBlogPost series.
	index := list indexOf: aFOBlogPost.
	^ (index < list size)
		ifTrue: [ list at: index + 1 ]
		ifFalse: [ nil ]
]

{ #category : #series }
FOBlog >> seriesPostBefore: aFOBlogPost [
	| list index |
	list := self postsInSeries: aFOBlogPost series.
	index := list indexOf: aFOBlogPost.
	^ (index > 1)
		ifTrue: [ list at: index - 1 ]
		ifFalse: [ nil ]
]

{ #category : #accessing }
FOBlog >> buildRssFeed [
	^ (FORSSVisitor new visit: self)
		parent: self;
		yourself
]

{ #category : #accessing }
FOBlog >> rssFeed [
	^ self
		propertyAt: #rssFeed
		ifAbsentPut: [ self buildRssFeed ]
]

{ #category : #sorting }
FOBlog >> sortedByPublishDate [
	^ self publishedPosts sorted: #publishDate ascending
]

{ #category : #accessing }
FOBlog >> title [
	^ title ifNil: [ 'Untitled' ]
]

{ #category : #accessing }
FOBlog >> title: aString [
	title := aString
]
