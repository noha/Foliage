Class {
	#name : #FOParagraph,
	#superclass : #FOBlockNode,
	#instVars : [
		'children'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #accessing }
FOParagraph >> children [
	^ children
]

{ #category : #accessing }
FOParagraph >> children: aCollection [
	children := aCollection
]

{ #category : #visiting }
FOParagraph >> acceptVisitor: aVisitor [
	^ aVisitor visitParagraph: self
]
