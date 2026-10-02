"
Abstract superclass of the block nodes. Besides the tree structure a block
carries the state the block parser needs while the document is being read:
whether it is still open, the raw lines accumulated so far and whether the last
line seen inside it was blank (which decides whether a list is tight or loose).

The parser asks a block polymorphically whether it continues on the current line
(#continueOn:), which children it accepts (#canContain:) and whether it swallows
raw lines (#acceptsLines); the default answers live here, the exceptions in the
subclasses.
"
Class {
	#name : #FOBlockNode,
	#superclass : #FONode,
	#instVars : [
		'open',
		'contentStream',
		'lastLineBlank',
		'lastLineChecked',
		'startLine'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #testing }
FOBlockNode >> absorbsBlankLine: aLineNumber [
	"Answer whether a blank line inside this block is part of it rather than a
	 separator that makes an enclosing list loose."
	^ false
]

{ #category : #testing }
FOBlockNode >> acceptsLines [
	"Leaf blocks made of raw text (paragraph, code block, html block) say true."
	^ false
]

{ #category : #parsing }
FOBlockNode >> appendLine: aString [
	contentStream ifNil: [ contentStream := WriteStream on: String new ].
	contentStream nextPutAll: aString; nextPut: Character lf
]

{ #category : #testing }
FOBlockNode >> blankLineTravelsToLastChild [
	"List structure passes the question on to its innermost block; every other
	 block answers for itself."
	^ false
]

{ #category : #testing }
FOBlockNode >> canContain: aBlockNode [
	"Container blocks say true for the children they accept."
	^ false
]

{ #category : #parsing }
FOBlockNode >> checkCloseOn: aParser [
	"Hook for blocks that end on a condition seen in the line just added."
]

{ #category : #parsing }
FOBlockNode >> close [
	open := false
]

{ #category : #accessing }
FOBlockNode >> content [
	^ contentStream
		ifNil: [ '' ]
		ifNotNil: [ :s | s contents ]
]

{ #category : #accessing }
FOBlockNode >> content: aString [
	contentStream := WriteStream on: String new.
	contentStream nextPutAll: aString
]

{ #category : #parsing }
FOBlockNode >> continueOn: aParser [
	"Answer #matched when this block continues on the parser's current line,
	 #notMatched when it does not and #lineConsumed when the block swallowed the
	 whole line and the parser must move on. Leaf blocks other than paragraphs
	 and code cannot be continued."
	^ #notMatched
]

{ #category : #testing }
FOBlockNode >> endsWithBlankLine [
	"Whether the last line seen inside this block was blank, which is what makes
	 an enclosing list loose. The answer is remembered, because the walk would
	 otherwise repeat itself for every item of a nested list."
	lastLineChecked ifTrue: [ ^ lastLineBlank ].
	lastLineChecked := true.
	(self blankLineTravelsToLastChild and: [ self lastChild notNil ])
		ifTrue: [ ^ self lastChild endsWithBlankLine ].
	^ lastLineBlank
]

{ #category : #parsing }
FOBlockNode >> finalizeOn: aParser [
	"Hook called when the block is closed."
]

{ #category : #testing }
FOBlockNode >> holdsInlines [
	"Blocks whose raw content is turned into inline nodes after the block
	 structure is known."
	^ false
]

{ #category : #initialization }
FOBlockNode >> initialize [
	super initialize.
	open := true.
	lastLineBlank := false.
	lastLineChecked := false
]

{ #category : #testing }
FOBlockNode >> isBlock [
	^ true
]

{ #category : #testing }
FOBlockNode >> isList [
	^ false
]

{ #category : #testing }
FOBlockNode >> isListItem [
	^ false
]

{ #category : #testing }
FOBlockNode >> isOpen [
	^ open
]

{ #category : #testing }
FOBlockNode >> isParagraph [
	^ false
]

{ #category : #testing }
FOBlockNode >> lastLineBlank [
	^ lastLineBlank
]

{ #category : #parsing }
FOBlockNode >> lastLineBlank: aBoolean [
	lastLineBlank := aBoolean
]

{ #category : #accessing }
FOBlockNode >> startLine [
	^ startLine
]

{ #category : #accessing }
FOBlockNode >> startLine: anInteger [
	startLine := anInteger
]
