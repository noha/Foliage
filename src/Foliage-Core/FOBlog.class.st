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
FOBlog >> adaptPage: aPage [
	^ aPage asFOBlogPost 
]

{ #category : #accessing }
FOBlog >> defaultLayout [

	^ 'blog'
]

{ #category : #converting }
FOBlog >> emitSlots [

	^ #(title layout)
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
		numberOfCharacters: 100; 
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
	^ items values select: #isPost
]

{ #category : #sorting }
FOBlog >> publishedPosts [
	^ self posts select: #isPublished
]

{ #category : #rendering }
FOBlog >> renderContextClass [

	^ FORenderContext
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

{ #category : #accessing }
FOBlog >> title [

	^ title ifNil: [ 'Untitled' ]
]

{ #category : #accessing }
FOBlog >> title: aString [

	title := aString
]
