Class {
	#name : #FOBlogPost,
	#superclass : #FOPillarPage,
	#category : #'Foliage-Core-Blog'
}

{ #category : #'as yet unclassified' }
FOBlogPost >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitBlogPost: self 
]

{ #category : #testing }
FOBlogPost >> isPost [ 
	^ true
]

{ #category : #'instance creation' }
FOBlogPost >> renderContextClass [ 
	^ FOBlogPostRenderContext 
]
