Class {
	#name : #FORenderContext,
	#superclass : #Object,
	#instVars : [
		'website'
	],
	#category : #'Foliage-Core-Base'
}

{ #category : #accessing }
FORenderContext >> layout [
	self subclassResponsibility 
]

{ #category : #accessing }
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
