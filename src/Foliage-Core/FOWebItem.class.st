Class {
	#name : #FOWebItem,
	#superclass : #Object,
	#instVars : [
		'parent'
	],
	#category : #'Foliage-Core'
}

{ #category : #testing }
FOWebItem >> isChildOf: anObject [
	^ self parent = anObject 
]

{ #category : #accessing }
FOWebItem >> parent [
	^ parent
]

{ #category : #accessing }
FOWebItem >> parent: anItem [
	parent := anItem
]
