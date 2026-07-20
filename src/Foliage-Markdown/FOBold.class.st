Class {
	#name : #FOBold,
	#superclass : #FOInlineNode,
	#instVars : [
		'text'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #accessing }
FOBold >> text [
	^ text
]

{ #category : #accessing }
FOBold >> text: aString [
	text := aString
]

{ #category : #visiting }
FOBold >> acceptVisitor: aVisitor [
	^ aVisitor visitBold: self
]
