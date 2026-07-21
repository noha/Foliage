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
	^ FOBlogOverviewBuilder new
		blog: self;
		buildSummary
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
