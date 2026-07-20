Class {
	#name : #FOLineReader,
	#superclass : #Object,
	#instVars : [
		'lines',
		'position'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #'instance creation' }
FOLineReader class >> on: aString [
	^ self new setSource: aString
]

{ #category : #initialization }
FOLineReader >> setSource: aString [
	lines := aString lines asOrderedCollection.
	position := 1
]

{ #category : #testing }
FOLineReader >> atEnd [
	^ position > lines size
]

{ #category : #accessing }
FOLineReader >> peek [
	^ self atEnd
		ifTrue: [ nil ]
		ifFalse: [ lines at: position ]
]

{ #category : #accessing }
FOLineReader >> next [
	| line |
	line := self peek.
	line ifNotNil: [ position := position + 1 ].
	^ line
]

{ #category : #indentation }
FOLineReader >> indentOf: aLine [
	| i |
	i := 1.
	[ i <= aLine size and: [ (aLine at: i) = $  ] ] whileTrue: [ i := i + 1 ].
	^ i - 1
]

{ #category : #indentation }
FOLineReader >> stripIndent: n from: aLine [
	| actual |
	actual := n min: (self indentOf: aLine).
	^ aLine copyFrom: actual + 1 to: aLine size
]
