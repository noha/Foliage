Class {
	#name : #FOBlog,
	#superclass : #Object,
	#instVars : [
		'posts'
	],
	#category : #'Foliage-Core'
}

{ #category : #'instance creation' }
FOBlog class >> posts: aCollection [ 
	^ self new 
		posts: aCollection 
]

{ #category : #summary }
FOBlog >> overviewPage [
	^ FOBlogOverviewBuilder new 
		posts: posts;
		numberOfCharacters: 600; 
		buildSummary
]

{ #category : #accessing }
FOBlog >> postAfter: aFOPillarPage [ 
	| list index |
	list := self sortedByPublishDate.
	index := list indexOf: aFOPillarPage.
	^ (index < list size)
		ifTrue: [ list at: index + 1 ]
		ifFalse: [ nil ]
]

{ #category : #accessing }
FOBlog >> postBefore: aFOPillarPage [ 
	| list index |
	list := self sortedByPublishDate.
	index := list indexOf: aFOPillarPage.
	^ (index > 1)
		ifTrue: [ list at: index - 1 ]
		ifFalse: [ nil ]
]

{ #category : #accessing }
FOBlog >> posts [
	^ posts
]

{ #category : #accessing }
FOBlog >> posts: anObject [
	posts := anObject
]

{ #category : #sorting }
FOBlog >> publishedPosts [
	^ posts select: #isPublished
]

{ #category : #sorting }
FOBlog >> sortedByPublishDate [
	^ self publishedPosts 
		sorted: #publishDate ascending
]
