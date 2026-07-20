Class {
	#name : #FOListItem,
	#superclass : #FOBlockNode,
	#instVars : [
		'text'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #accessing }
FOListItem >> text [
	^ text
]

{ #category : #accessing }
FOListItem >> text: aString [
	text := aString
]

{ #category : #visiting }
FOListItem >> acceptVisitor: aVisitor [
	^ aVisitor visitListItem: self
]
