Class {
	#name : #FOBlog,
	#superclass : #FOWebFolder,
	#category : #'Foliage-Core-Blog'
}

{ #category : #'as yet unclassified' }
FOBlog >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitBlog: self 
]

{ #category : #'as yet unclassified' }
FOBlog >> adaptPage: aPage [
	^ aPage asFOBlogPost 
]

{ #category : #accessing }
FOBlog >> at: key put: value [
	super 
		at: key 
		put: value 
]

{ #category : #'as yet unclassified' }
FOBlog >> overviewPage [
	^ FOBlogOverviewBuilder new 
		posts: self posts;
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

{ #category : #'as yet unclassified' }
FOBlog >> posts [
	^ items values select: #isPost
]

{ #category : #sorting }
FOBlog >> publishedPosts [
	^ self posts select: #isPublished
]

{ #category : #resolving }
FOBlog >> resolvePath: aRelativePath [ 
	aRelativePath isEmpty ifTrue: [ 
		^ self ].
	^ items 
		at: aRelativePath segments first
		ifAbsent: [ 
			Error signal: 'no child with name ', aRelativePath segments first ].

]

{ #category : #sorting }
FOBlog >> sortedByPublishDate [
	^ self publishedPosts 
		sorted: #publishDate ascending
]
