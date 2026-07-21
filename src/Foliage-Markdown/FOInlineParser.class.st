Class {
	#name : #FOInlineParser,
	#superclass : #Object,
	#category : #'Foliage-Markdown'
}

{ #category : #'instance creation' }
FOInlineParser class >> parse: aString [
	^ self new parse: aString
]

{ #category : #parsing }
FOInlineParser >> parse: aString [
	| nodes i bufferStart result |
	nodes := OrderedCollection new.
	i := 1.
	bufferStart := 1.
	[ i <= aString size ] whileTrue: [
		result := (self isTriggerChar: (aString at: i))
			ifTrue: [ self tryParseAt: i in: aString ]
			ifFalse: [ nil ].
		result
			ifNotNil: [
				i > bufferStart ifTrue: [
					nodes add: (FOText new string: (aString copyFrom: bufferStart to: i - 1); yourself) ].
				nodes add: result first.
				i := result second.
				bufferStart := i ]
			ifNil: [ i := i + 1 ] ].
	i > bufferStart ifTrue: [
		nodes add: (FOText new string: (aString copyFrom: bufferStart to: i - 1); yourself) ].
	^ nodes
]

{ #category : #private }
FOInlineParser >> isTriggerChar: aChar [
	^ aChar = $* or: [ aChar = $_ or: [ aChar = $[ or: [ aChar = $! ] ] ]
]

{ #category : #private }
FOInlineParser >> tryParseAt: i in: aString [
	| char |
	char := aString at: i.
	char = $* ifTrue: [ ^ self tryParseBoldAt: i in: aString delimiter: '**' ].
	char = $_ ifTrue: [
		(i + 1 <= aString size and: [ (aString at: i + 1) = $_ ])
			ifTrue: [ ^ self tryParseBoldAt: i in: aString delimiter: '__' ].
		^ self tryParseItalicAt: i in: aString ].
	char = $! ifTrue: [ ^ self tryParseImageAt: i in: aString ].
	char = $[ ifTrue: [ ^ self tryParseLinkAt: i in: aString ].
	^ nil
]

{ #category : #private }
FOInlineParser >> tryParseBoldAt: i in: aString delimiter: aDelimiter [
	"Real content (noha.github.io/raw/blog/2020-10-24_a-website-model.md,
	2020-10-06_on-to-number-2.md) uses __bold__ (double underscore)
	alongside **bold** - both delimiters mean the same FOBold node."
	| closeIndex text |
	(i + aDelimiter size - 1 <= aString size
		and: [ (aString copyFrom: i to: i + aDelimiter size - 1) = aDelimiter ])
		ifFalse: [ ^ nil ].
	closeIndex := aString indexOfSubCollection: aDelimiter startingAt: i + aDelimiter size.
	closeIndex = 0 ifTrue: [ ^ nil ].
	text := aString copyFrom: i + aDelimiter size to: closeIndex - 1.
	^ { FOBold new text: text; yourself. closeIndex + aDelimiter size }
]

{ #category : #private }
FOInlineParser >> tryParseItalicAt: i in: aString [
	| closeIndex text |
	closeIndex := aString indexOf: $_ startingAt: i + 1.
	closeIndex = 0 ifTrue: [ ^ nil ].
	text := aString copyFrom: i + 1 to: closeIndex - 1.
	text isEmpty ifTrue: [ ^ nil ].
	^ { FOItalic new text: text; yourself. closeIndex + 1 }
]

{ #category : #private }
FOInlineParser >> tryParseLinkAt: i in: aString [
	| bracketClose parenClose text url |
	bracketClose := aString indexOf: $] startingAt: i + 1.
	bracketClose = 0 ifTrue: [ ^ nil ].
	(bracketClose + 1 <= aString size and: [ (aString at: bracketClose + 1) = $( ]) ifFalse: [ ^ nil ].
	parenClose := aString indexOf: $) startingAt: bracketClose + 2.
	parenClose = 0 ifTrue: [ ^ nil ].
	text := aString copyFrom: i + 1 to: bracketClose - 1.
	url := aString copyFrom: bracketClose + 2 to: parenClose - 1.
	^ { FOLink new text: text; url: url; yourself. parenClose + 1 }
]

{ #category : #private }
FOInlineParser >> tryParseImageAt: i in: aString [
	| bracketClose parenClose alt inner spaceIndex src attributes attrString |
	(i + 1 <= aString size and: [ (aString at: i + 1) = $[ ]) ifFalse: [ ^ nil ].
	bracketClose := aString indexOf: $] startingAt: i + 2.
	bracketClose = 0 ifTrue: [ ^ nil ].
	(bracketClose + 1 <= aString size and: [ (aString at: bracketClose + 1) = $( ]) ifFalse: [ ^ nil ].
	parenClose := aString indexOf: $) startingAt: bracketClose + 2.
	parenClose = 0 ifTrue: [ ^ nil ].
	alt := aString copyFrom: i + 2 to: bracketClose - 1.
	inner := aString copyFrom: bracketClose + 2 to: parenClose - 1.
	spaceIndex := inner indexOf: $ .
	attributes := Dictionary new.
	spaceIndex = 0
		ifTrue: [ src := inner ]
		ifFalse: [
			src := inner copyFrom: 1 to: spaceIndex - 1.
			attrString := (inner copyFrom: spaceIndex + 1 to: inner size) trimBoth.
			self parseAttributes: attrString into: attributes ].
	^ { (FOImage new alt: alt; src: src; attributes: attributes; yourself). parenClose + 1 }
]

{ #category : #private }
FOInlineParser >> parseAttributes: aString into: aDictionary [
	(aString substrings: ' ') do: [ :pair |
		| eq |
		eq := pair indexOf: $=.
		eq = 0 ifFalse: [
			aDictionary
				at: (pair copyFrom: 1 to: eq - 1) asSymbol
				put: (pair copyFrom: eq + 1 to: pair size) ] ]
]
