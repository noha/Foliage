Class {
	#name : #FOBlogOverviewBuilder,
	#superclass : #Object,
	#instVars : [
		'folder'
	],
	#category : #'Foliage-Core'
}

{ #category : #accessing }
FOBlogOverviewBuilder >> folder: aFOWebFolder [ 
	folder := aFOWebFolder 
]

{ #category : #'page creation' }
FOBlogOverviewBuilder >> overviewPage [
	| posts abstracts |
	posts := self publishedPosts.
	abstracts := posts collect: [ :post |
		FOPillarTruncateVisitor new 
			size: (300 to: 600);
			post: post  ].
	self flag: #todo.
	"how to organite layouts for in-memory pages??"
	^ FOPillarPage new 
		metaAt: 'layout' put: 'page';
		pillar: (PRDocument new
			setChildren: (abstracts flatCollect: #children);
			yourself)
]

{ #category : #'page creation' }
FOBlogOverviewBuilder >> publishedPosts [
	^ (folder allPages 
		select: #isPublished)
			sorted: [ :a :b | a publishDate > b publishDate ]
]
