Class {
	#name : #FORenderContext,
	#superclass : #Object,
	#instVars : [
		'website',
		'page'
	],
	#category : #'Foliage-Core'
}

{ #category : #accessing }
FORenderContext >> at: key [ 
	self halt.
]

{ #category : #accessing }
FORenderContext >> body [ 
	^ self html
]

{ #category : #accessing }
FORenderContext >> html [
	^ String streamContents: [ :s| 
		page renderOn: s ].
]

{ #category : #accessing }
FORenderContext >> page [
	^ page
]

{ #category : #accessing }
FORenderContext >> page: anObject [
	page := anObject
]

{ #category : #'as yet unclassified' }
FORenderContext >> partials [ 
	^ FOPartialProvider new 
		layout: page layout; 
		website: website
]

{ #category : #rendering }
FORenderContext >> renderTemplate: template [
	^ template 
		value: self 
		partials: self partials.
]

{ #category : #accessing }
FORenderContext >> website [
	^ website
]

{ #category : #accessing }
FORenderContext >> website: anObject [
	website := anObject
]
