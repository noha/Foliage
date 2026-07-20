Class {
	#name : #FOBlockquote,
	#superclass : #FOBlockNode,
	#instVars : [
		'text'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #accessing }
FOBlockquote >> text [
	^ text
]

{ #category : #accessing }
FOBlockquote >> text: aString [
	text := aString
]

{ #category : #visiting }
FOBlockquote >> acceptVisitor: aVisitor [
	^ aVisitor visitBlockquote: self
]
