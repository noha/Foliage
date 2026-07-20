Class {
	#name : #FOItalic,
	#superclass : #FOInlineNode,
	#instVars : [
		'text'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #accessing }
FOItalic >> text [
	^ text
]

{ #category : #accessing }
FOItalic >> text: aString [
	text := aString
]

{ #category : #visiting }
FOItalic >> acceptVisitor: aVisitor [
	^ aVisitor visitItalic: self
]
