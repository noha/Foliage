Class {
	#name : #FOBlogPostRenderContext,
	#superclass : #FOPageRenderContext,
	#category : #'Foliage-Core-Blog'
}

{ #category : #'as yet unclassified' }
FOBlogPostRenderContext >> nextPost [ 
	^ page parent postAfter: self page
]

{ #category : #'as yet unclassified' }
FOBlogPostRenderContext >> previousPost [ 
	^ page parent postBefore: self page
]
