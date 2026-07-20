Class {
	#name : #FOListItem,
	#superclass : #FOBlockNode,
	#instVars : [
		'children'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #accessing }
FOListItem >> children [
	^ children
]

{ #category : #accessing }
FOListItem >> children: aCollection [
	children := aCollection
]

{ #category : #visiting }
FOListItem >> acceptVisitor: aVisitor [
	^ aVisitor visitListItem: self
]
