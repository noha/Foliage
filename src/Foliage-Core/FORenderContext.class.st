Class {
	#name : #FORenderContext,
	#superclass : #Object,
	#instVars : [
		'website'
	],
	#category : #'Foliage-Core-Base'
}

{ #category : #'as yet unclassified' }
FORenderContext >> layout [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
FORenderContext >> partials [ 
	^ FOPartialProvider new 
		layout: self layout; 
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
