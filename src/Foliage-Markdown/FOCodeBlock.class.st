"
Abstract superclass of the two kinds of code block. The code is kept verbatim
and is escaped, never inline-parsed, when rendered.

#language is derived from the info string of a fenced block. Besides the
CommonMark spelling (```smalltalk) Foliage also accepts its own older
```language=smalltalk, which appears throughout the existing blog sources.
"
Class {
	#name : #FOCodeBlock,
	#superclass : #FOBlockNode,
	#instVars : [
		'code'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #visiting }
FOCodeBlock >> acceptVisitor: aVisitor [
	^ aVisitor visitCodeBlock: self
]

{ #category : #testing }
FOCodeBlock >> acceptsLines [
	^ true
]

{ #category : #accessing }
FOCodeBlock >> code [
	^ code ifNil: [ '' ]
]

{ #category : #accessing }
FOCodeBlock >> code: aString [
	code := aString
]

{ #category : #accessing }
FOCodeBlock >> info [
	"Only fenced blocks carry an info string."
	^ nil
]

{ #category : #accessing }
FOCodeBlock >> kind [
	^ self subclassResponsibility
]

{ #category : #accessing }
FOCodeBlock >> language [
	| words first |
	self info ifNil: [ ^ nil ].
	words := self info substrings.
	words ifEmpty: [ ^ nil ].
	first := words first.
	^ (first beginsWith: 'language=')
		ifTrue: [ first allButFirst: 'language=' size ]
		ifFalse: [ first ]
]
