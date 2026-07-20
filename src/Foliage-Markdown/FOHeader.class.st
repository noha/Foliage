Class {
	#name : #FOHeader,
	#superclass : #FOBlockNode,
	#instVars : [
		'level',
		'children'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #accessing }
FOHeader >> level [
	^ level
]

{ #category : #accessing }
FOHeader >> level: anInteger [
	level := anInteger
]

{ #category : #accessing }
FOHeader >> children [
	^ children
]

{ #category : #accessing }
FOHeader >> children: aCollection [
	children := aCollection
]

{ #category : #visiting }
FOHeader >> acceptVisitor: aVisitor [
	^ aVisitor visitHeader: self
]
