Class {
	#name : #FOParagraph,
	#superclass : #FOBlockNode,
	#instVars : [
		'text'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #accessing }
FOParagraph >> text [
	^ text
]

{ #category : #accessing }
FOParagraph >> text: aString [
	text := aString
]

{ #category : #visiting }
FOParagraph >> acceptVisitor: aVisitor [
	^ aVisitor visitParagraph: self
]
