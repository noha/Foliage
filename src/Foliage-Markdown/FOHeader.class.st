"
An ATX heading (# ...) or a setext heading (text underlined with = or -).
"
Class {
	#name : #FOHeader,
	#superclass : #FOBlockNode,
	#instVars : [
		'level'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #visiting }
FOHeader >> acceptVisitor: aVisitor [
	^ aVisitor visitHeader: self
]

{ #category : #testing }
FOHeader >> holdsInlines [
	^ true
]

{ #category : #accessing }
FOHeader >> level [
	^ level
]

{ #category : #accessing }
FOHeader >> level: anInteger [
	level := anInteger
]
