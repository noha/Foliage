Class {
	#name : #FOListParserTest,
	#superclass : #TestCase,
	#category : #'Foliage-Markdown-Tests'
}

{ #category : #private }
FOListParserTest >> nl [
	^ String with: Character lf
]

{ #category : #private }
FOListParserTest >> parse: aString [
	^ FOListParser parseFrom: (FOLineReader on: aString)
]

{ #category : #private }
FOListParserTest >> textOf: aListItem [
	^ String streamContents: [ :s |
		aListItem children do: [ :c |
			(c isKindOf: FOText)
				ifTrue: [ s nextPutAll: c string ]
				ifFalse: [ s nextPutAll: c text ] ] ]
]

{ #category : #tests }
FOListParserTest >> testFlatUnorderedList [
	| list |
	list := self parse: '- A', self nl, '- B', self nl, '- C'.
	self assert: list ordered equals: false.
	self assert: (list items collect: [ :i | self textOf: i ]) asArray equals: #('A' 'B' 'C').
	self assert: (list items allSatisfy: [ :i | i nestedList isNil ])
]

{ #category : #tests }
FOListParserTest >> testNestingUnderFirstItem [
	"The syntax.md fixture case: an ordered sublist nested 2-space-indented under an unordered item."
	| list a |
	list := self parse:
		'- A', self nl,
		'  1. first', self nl,
		'  2. second', self nl,
		'- B', self nl,
		'- C'.
	self assert: list items size equals: 3.
	a := list items first.
	self assert: (self textOf: a) equals: 'A'.
	self assert: a nestedList notNil.
	self assert: a nestedList ordered equals: true.
	self assert: (a nestedList items collect: [ :i | self textOf: i ]) asArray equals: #('first' 'second').
	self assert: list items second nestedList isNil.
	self assert: list items third nestedList isNil
]

{ #category : #tests }
FOListParserTest >> testNestingUnderMiddleItem [
	| list b |
	list := self parse:
		'- A', self nl,
		'- B', self nl,
		'  1. first', self nl,
		'- C'.
	self assert: list items size equals: 3.
	self assert: list items first nestedList isNil.
	b := list items second.
	self assert: (self textOf: b) equals: 'B'.
	self assert: b nestedList notNil.
	self assert: (b nestedList items collect: [ :i | self textOf: i ]) asArray equals: #('first').
	self assert: list items third nestedList isNil
]

{ #category : #tests }
FOListParserTest >> testOrderedOuterUnorderedInnerNeedsThreeSpaceNesting [
	"An ordered marker '1. ' is 3 chars, so correct nesting needs 3 spaces,
	 not a hardcoded 2 - this generalizes the syntax.md fixture's own case."
	| list first |
	list := self parse:
		'1. first', self nl,
		'   - nested a', self nl,
		'   - nested b', self nl,
		'2. second'.
	self assert: list ordered equals: true.
	self assert: list items size equals: 2.
	first := list items first.
	self assert: first nestedList notNil.
	self assert: first nestedList ordered equals: false.
	self assert: (first nestedList items collect: [ :i | self textOf: i ]) asArray equals: #('nested a' 'nested b').
	self assert: list items second nestedList isNil
]

{ #category : #tests }
FOListParserTest >> testTooShallowIndentIsNotTreatedAsNested [
	"contentColumn for '1. ' is 3; 2 spaces of indent falls short, so this
	 line neither nests under item 1 nor continues the outer list."
	| list |
	list := self parse: '1. first', self nl, '  - too shallow'.
	self assert: list items size equals: 1.
	self assert: list items first nestedList isNil
]
