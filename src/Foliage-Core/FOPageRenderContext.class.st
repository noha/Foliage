Class {
	#name : #FOPageRenderContext,
	#superclass : #FORenderContext,
	#instVars : [
		'page'
	],
	#category : #'Foliage-Core-Base'
}

{ #category : #accessing }
FOPageRenderContext >> body [ 
	^ self html
]

{ #category : #accessing }
FOPageRenderContext >> html [
	^ String streamContents: [ :s| 
		page renderOn: s ].
]

{ #category : #'as yet unclassified' }
FOPageRenderContext >> layout [
	^ page layout
]

{ #category : #accessing }
FOPageRenderContext >> page [
	^ page
]

{ #category : #accessing }
FOPageRenderContext >> page: anObject [
	page := anObject
]
