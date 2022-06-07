Class {
	#name : #FOBlogPostRenderContext,
	#superclass : #FOPageRenderContext,
	#category : #'Foliage-Core-Blog'
}

{ #category : #accessing }
FOBlogPostRenderContext >> abstract [

	^ self page abstract
]

{ #category : #'as yet unclassified' }
FOBlogPostRenderContext >> nextPost [ 
	^ page parent postAfter: self page
]

{ #category : #accessing }
FOBlogPostRenderContext >> pathString [

	^ page pathString
]

{ #category : #'as yet unclassified' }
FOBlogPostRenderContext >> previousPost [ 
	^ page parent postBefore: self page
]

{ #category : #accessing }
FOBlogPostRenderContext >> title [

	^ self page title
]
