Class {
	#name : #FOListParser,
	#superclass : #Object,
	#category : #'Foliage-Markdown'
}

{ #category : #'instance creation' }
FOListParser class >> parseFrom: aReader [
	^ self new parseFrom: aReader
]

{ #category : #parsing }
FOListParser >> parseFrom: aReader [
	| first ordered indent items |
	first := FOLineClassifier classify: aReader peek.
	ordered := first ordered.
	indent := first indent.
	items := OrderedCollection new.
	[ self matchesListItem: aReader ordered: ordered indent: indent ]
		whileTrue: [ items add: (self consumeItem: aReader) ].
	^ FOList new ordered: ordered; items: items; yourself
]

{ #category : #private }
FOListParser >> matchesListItem: aReader ordered: aBoolean indent: anIndent [
	| c |
	aReader atEnd ifTrue: [ ^ false ].
	c := FOLineClassifier classify: aReader peek.
	^ (c kind = #unorderedListItem or: [ c kind = #orderedListItem ])
		and: [ c ordered = aBoolean and: [ c indent = anIndent ] ]
]

{ #category : #private }
FOListParser >> consumeItem: aReader [
	| classification line text item |
	classification := FOLineClassifier classify: aReader peek.
	line := aReader next.
	text := (line copyFrom: classification contentColumn + 1 to: line size) trimBoth.
	item := FOListItem new children: (FOInlineParser parse: text); yourself.
	(self startsNestedListIn: aReader contentColumn: classification contentColumn)
		ifTrue: [ item nestedList: (self parseFrom: aReader) ].
	^ item
]

{ #category : #private }
FOListParser >> startsNestedListIn: aReader contentColumn: aContentColumn [
	| c |
	aReader atEnd ifTrue: [ ^ false ].
	c := FOLineClassifier classify: aReader peek.
	^ (c kind = #unorderedListItem or: [ c kind = #orderedListItem ])
		and: [ c indent >= aContentColumn ]
]
