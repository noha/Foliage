Class {
	#name : #FOBlogPostRenderContext,
	#superclass : #FOPageRenderContext,
	#instVars : [
		'post'
	],
	#category : #'Foliage-Core-Base'
}

{ #category : #'as yet unclassified' }
FOBlogPostRenderContext >> nextPost [ 
	^ page parent postAfter: self page
]

{ #category : #accessing }
FOBlogPostRenderContext >> post [
	^ post
]

{ #category : #accessing }
FOBlogPostRenderContext >> post: anObject [
self halt.
	post := anObject
]

{ #category : #'as yet unclassified' }
FOBlogPostRenderContext >> previousPost [ 
	^ page parent postBefore: self page
]
