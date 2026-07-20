Class {
	#name : #FOHeader,
	#superclass : #FOBlockNode,
	#instVars : [
		'level',
		'text'
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
FOHeader >> text [
	^ text
]

{ #category : #accessing }
FOHeader >> text: aString [
	text := aString
]

{ #category : #visiting }
FOHeader >> acceptVisitor: aVisitor [
	^ aVisitor visitHeader: self
]
