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

{ #category : #accessing }
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

{ #category : #accessing }
FOPageRenderContext >> publicationDate [

	^ page publicationDate
]

{ #category : #accessing }
FOPageRenderContext >> title [

	^ page title
]
