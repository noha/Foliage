Class {
	#name : #FOText,
	#superclass : #FOInlineNode,
	#instVars : [
		'string'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #accessing }
FOText >> string [
	^ string
]

{ #category : #accessing }
FOText >> string: aString [
	string := aString
]

{ #category : #visiting }
FOText >> acceptVisitor: aVisitor [
	^ aVisitor visitText: self
]
