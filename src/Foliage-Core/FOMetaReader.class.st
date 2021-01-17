Class {
	#name : #FOMetaReader,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #'Foliage-Core-Reader'
}

{ #category : #'as yet unclassified' }
FOMetaReader class >> on: aReadStream [ 
	^ self new 
		stream: aReadStream
]

{ #category : #'as yet unclassified' }
FOMetaReader class >> parse: aString [ 
	^ self new parse: aString
]

{ #category : #'as yet unclassified' }
FOMetaReader >> next [
	^ self readLines 
]

{ #category : #'as yet unclassified' }
FOMetaReader >> parse: aString [ 
	stream := ZnCharacterReadStream on: aString asByteArray readStream encoding: #utf8.
	^ self readLines
]

{ #category : #'as yet unclassified' }
FOMetaReader >> readLine [
	| line parts key vparts |
	line := stream nextLine.
	line isEmpty ifTrue: [ ^ nil ].
	parts := $: split: line.
	key := parts first trimBoth.
	vparts := $; split: parts second.
	^ key -> ((vparts size = 1) 
		ifTrue: [ vparts first trimBoth]
		ifFalse: [ vparts collect: #trimBoth ])
]

{ #category : #'as yet unclassified' }
FOMetaReader >> readLines [
	| properties line |
	properties := Dictionary new.
	line := ''.
	[ stream atEnd or: [ line isNil ] ] whileFalse: [ 
		line := self readLine.
		line ifNotNil: [
			properties add: line ]].
	^ properties
]

{ #category : #'as yet unclassified' }
FOMetaReader >> stream: aZnCharacterReadStream [ 
	stream := aZnCharacterReadStream
]
