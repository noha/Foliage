"
I'm in charge of reading the Foliage Metadata header and return read properties.

A valid header can be a Yaml metadata block :
```mardown
---
title: Some news
layout: post
---
<html>
```
or a list of properties followed by a blanck line:
```mardown
title: Some news
layout: post

<html>
```
"
Class {
	#name : #FOMetaReader,
	#superclass : #Object,
	#instVars : [
		'stream',
		'line',
		'isYamlMetadataBlock'
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

{ #category : #testing }
FOMetaReader >> isEndOfMetadataBlock [
	^ isYamlMetadataBlock 
		ifTrue: [ self isEndOfYamlMetadataBlock ]
		ifFalse: [ line isEmpty ]
]

{ #category : #testing }
FOMetaReader >> isEndOfYamlMetadataBlock [
	^ isYamlMetadataBlock and: [ self isYamlSeparator ]
]

{ #category : #testing }
FOMetaReader >> isYamlSeparator [
	^ line trimBoth = '---'
]

{ #category : #accessing }
FOMetaReader >> next [
	^ self readLines 
]

{ #category : #parsing }
FOMetaReader >> parse: aString [ 
	stream := ZnCharacterReadStream on: aString asByteArray readStream encoding: #utf8.
	^ self readLines
]

{ #category : #converting }
FOMetaReader >> propertyFrom: aLine [
	| parts key vparts |

	parts := $: split: aLine.
	parts size = 1 
		ifTrue: [ FoMetadataHeaderBadFormat 
						signal: 'invalid metadata syntax (key: value) or missing metadata separator' ].
	key := parts first trimBoth.
	vparts := $; split: parts second.
	^ key -> ((vparts size = 1) 
		ifTrue: [ vparts first trimBoth]
		ifFalse: [ vparts collect: #trimBoth ])
]

{ #category : #parsing }
FOMetaReader >> readLine [

	line := stream nextLine
]

{ #category : #parsing }
FOMetaReader >> readLines [
	| properties |
	
	self readLine.
	isYamlMetadataBlock := self isYamlSeparator.

	properties := Dictionary new.
	[ self readLine. stream atEnd or: [ self isEndOfMetadataBlock ] ] whileFalse: [ 
		| property |
		property := self propertyFrom: line.
		property ifNotNil: [ properties add: property ] ].
	^ properties
]

{ #category : #accessing }
FOMetaReader >> stream: aZnCharacterReadStream [ 
	stream := aZnCharacterReadStream
]
