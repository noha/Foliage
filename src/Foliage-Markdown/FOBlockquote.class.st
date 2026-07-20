Class {
	#name : #FOBlockquote,
	#superclass : #FOBlockNode,
	#instVars : [
		'children'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #accessing }
FOBlockquote >> children [
	^ children
]

{ #category : #accessing }
FOBlockquote >> children: aCollection [
	children := aCollection
]

{ #category : #visiting }
FOBlockquote >> acceptVisitor: aVisitor [
	^ aVisitor visitBlockquote: self
]
