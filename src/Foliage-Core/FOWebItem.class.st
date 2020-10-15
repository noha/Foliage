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

{ #category : #accessing }
FOWebItem >> root [ 	
	^ parent root
]

{ #category : #'as yet unclassified' }
FOWebItem >> website [ 
	^ self root website
]
