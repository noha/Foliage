Class {
	#name : #FOBlogPost,
	#superclass : #FOPillarPage,
	#category : #'Foliage-Core-Blog'
}

{ #category : #accessing }
FOBlogPost >> abstract [

	^ super abstract
]

{ #category : #accessing }
FOBlogPost >> abstractLayout [

	^ self meta 
		at: 'abstractLayout'
		ifAbsent: [ self defaultAbstractLayout ]	
]

{ #category : #accessing }
FOBlogPost >> abstractTemplate [

	^ (self website templatePathForLayout: self abstractLayout) asMustacheTemplate.
]

{ #category : #visiting }
FOBlogPost >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitBlogPost: self 
]

{ #category : #accessing }
FOBlogPost >> defaultAbstractLayout [

	^ 'blogpostabstract'
]

{ #category : #accessing }
FOBlogPost >> defaultLayout [

	^ 'blogpost'
]

{ #category : #testing }
FOBlogPost >> isPost [

	^ true
]

{ #category : #accessing }
FOBlogPost >> publicationDate [

	^ self meta 
		at: 'publishDate'
		ifPresent: [ :aString | (aString copyWithout: $") asDate ]
		ifAbsent: [ nil ]
]

{ #category : #accessing }
FOBlogPost >> renderAbstract [

	^ self newRenderContext renderTemplate: self abstractTemplate
]

{ #category : #'instance creation' }
FOBlogPost >> renderContextClass [

	^ FOBlogPostRenderContext 
]
