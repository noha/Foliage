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
			size: (300 to: 400);
			post: post ].
	^ FOPillarPage new 
		metaAt: 'layout' put: 'page';
		pillar: (PRDocument new
			setChildren: (abstracts flatCollect: #children);
			yourself)
	"html := String streamContents: [ :stream |
		FOPillarHTMLVisitor new
		stream: stream;
		visitAll: excerpts;
		flush ]."		
]

{ #category : #'page creation' }
FOBlogOverviewBuilder >> publishedPosts [
	^ (folder allPages 
		select: #isPublished)
			sorted: [ :a :b | a publishDate > b publishDate ]
]
