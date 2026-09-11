"
A block quote. Its children are blocks, so a quote can hold paragraphs, lists,
code and further quotes.
"
Class {
	#name : #FOBlockquote,
	#superclass : #FOBlockNode,
	#category : #'Foliage-Markdown'
}

{ #category : #testing }
FOBlockquote >> absorbsBlankLine: aLineNumber [
	^ true
]

{ #category : #visiting }
FOBlockquote >> acceptVisitor: aVisitor [
	^ aVisitor visitBlockquote: self
]

{ #category : #testing }
FOBlockquote >> canContain: aBlockNode [
	^ aBlockNode isListItem not
]

{ #category : #parsing }
FOBlockquote >> continueOn: aParser [
	| scanner |
	scanner := aParser scanner.
	(scanner isIndented not and: [ scanner peekAtNextNonspace = $> ])
		ifFalse: [ ^ #notMatched ].
	scanner advanceNextNonspace.
	scanner advanceOffset: 1 columns: false.
	(FOSyntax isSpaceOrTab: scanner peek) ifTrue: [ scanner advanceOffset: 1 columns: true ].
	^ #matched
]
