"
A code block delimited by a row of backticks or tildes. The rest of the opening
fence line is the info string, whose first word names the language.
"
Class {
	#name : #FOFencedCodeBlock,
	#superclass : #FOCodeBlock,
	#instVars : [
		'info',
		'fenceChar',
		'fenceLength',
		'fenceOffset'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #testing }
FOFencedCodeBlock >> absorbsBlankLine: aLineNumber [
	^ true
]

{ #category : #parsing }
FOFencedCodeBlock >> continueOn: aParser [
	| scanner closingLength remaining |
	scanner := aParser scanner.
	closingLength := (scanner indent <= 3 and: [ scanner peekAtNextNonspace = fenceChar ])
		ifTrue: [ FOSyntax closingFenceLengthIn: scanner line from: scanner nextNonspace + 1 char: fenceChar ]
		ifFalse: [ 0 ].
	closingLength >= fenceLength ifTrue: [
		aParser finalizeBlock: self.
		^ #lineConsumed ].
	"An opening fence indented by n spaces lets the content be indented by up to n as well."
	remaining := fenceOffset.
	[ remaining > 0 and: [ FOSyntax isSpaceOrTab: scanner peek ] ] whileTrue: [
		scanner advanceOffset: 1 columns: true.
		remaining := remaining - 1 ].
	^ #matched
]

{ #category : #accessing }
FOFencedCodeBlock >> fenceChar [
	^ fenceChar
]

{ #category : #accessing }
FOFencedCodeBlock >> fenceChar: aCharacter [
	fenceChar := aCharacter
]

{ #category : #accessing }
FOFencedCodeBlock >> fenceLength [
	^ fenceLength
]

{ #category : #accessing }
FOFencedCodeBlock >> fenceLength: anInteger [
	fenceLength := anInteger
]

{ #category : #accessing }
FOFencedCodeBlock >> fenceOffset [
	^ fenceOffset
]

{ #category : #accessing }
FOFencedCodeBlock >> fenceOffset: anInteger [
	fenceOffset := anInteger
]

{ #category : #parsing }
FOFencedCodeBlock >> finalizeOn: aParser [
	| contents newlineIndex |
	contents := self content.
	newlineIndex := contents indexOf: Character lf.
	newlineIndex = 0
		ifTrue: [
			info := FOSyntax unescapeString: contents trimBoth.
			self code: '' ]
		ifFalse: [
			info := FOSyntax unescapeString: (contents first: newlineIndex - 1) trimBoth.
			self code: (contents allButFirst: newlineIndex) ]
]

{ #category : #accessing }
FOFencedCodeBlock >> info [
	^ info
]

{ #category : #accessing }
FOFencedCodeBlock >> info: aString [
	info := aString
]

{ #category : #accessing }
FOFencedCodeBlock >> kind [
	^ #fenced
]
