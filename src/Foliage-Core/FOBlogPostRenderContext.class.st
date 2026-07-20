Class {
	#name : #FOBlogPostRenderContext,
	#superclass : #FOPageRenderContext,
	#category : #'Foliage-Core-Blog'
}

{ #category : #accessing }
FOBlogPostRenderContext >> abstract [
	^ self page abstract
]

{ #category : #accessing }
FOBlogPostRenderContext >> nextPost [
	^ page parent postAfter: self page
]

{ #category : #accessing }
FOBlogPostRenderContext >> pathString [
	^ page pathString
]

{ #category : #accessing }
FOBlogPostRenderContext >> previousPost [
	^ page parent postBefore: self page
]
