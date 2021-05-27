Class {
	#name : #FOWebBlog,
	#superclass : #FOWebFolder,
	#category : #'Foliage-Core-Blog'
}

{ #category : #'as yet unclassified' }
FOWebBlog >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitBlog: self 
]

{ #category : #'as yet unclassified' }
FOWebBlog >> adaptPage: aPage [
	^ aPage asFOBlogPost 
]

{ #category : #accessing }
FOWebBlog >> at: key put: value [
	super 
		at: key 
		put: value 
]

{ #category : #'as yet unclassified' }
FOWebBlog >> overviewPage [
	^ FOBlogOverviewBuilder new 
		posts: self posts;
		numberOfCharacters: 600; 
		buildSummary
]

{ #category : #accessing }
FOWebBlog >> postAfter: aFOPillarPage [ 
	| list index |
	list := self sortedByPublishDate.
	index := list indexOf: aFOPillarPage.
	^ (index < list size)
		ifTrue: [ list at: index + 1 ]
		ifFalse: [ nil ]
]

{ #category : #accessing }
FOWebBlog >> postBefore: aFOPillarPage [ 
	| list index |
	list := self sortedByPublishDate.
	index := list indexOf: aFOPillarPage.
	^ (index > 1)
		ifTrue: [ list at: index - 1 ]
		ifFalse: [ nil ]
]

{ #category : #'as yet unclassified' }
FOWebBlog >> posts [
	^ items values select: #isPost
]

{ #category : #sorting }
FOWebBlog >> publishedPosts [
	^ self posts select: #isPublished
]

{ #category : #resolving }
FOWebBlog >> resolve: aRelativePath [ 
	aRelativePath isEmpty ifTrue: [ 
		^ self ].
	^ items 
		at: aRelativePath segments first
		ifAbsent: [ 
			Error signal: 'no child with name ', aRelativePath segments first ].

]

{ #category : #sorting }
FOWebBlog >> sortedByPublishDate [
	^ self publishedPosts 
		sorted: #publishDate ascending
]
