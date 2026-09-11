"
Builds the block structure of a markdown document, following the two phase
strategy CommonMark describes: this phase reads the source line by line and
maintains a stack of open container blocks; the inline content of the leaf
blocks is parsed afterwards, once the whole document (and with it every link
reference definition) is known.

For each line the parser first asks the open blocks whether they continue
(#continueOn:), then looks for new block starts, and finally hands whatever is
left of the line to the deepest block that takes raw lines.
"
Class {
	#name : #FOBlockParser,
	#superclass : #Object,
	#instVars : [
		'document',
		'tip',
		'oldTip',
		'lastMatchedContainer',
		'allClosed',
		'scanner',
		'lineNumber',
		'inlineParser'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #'instance creation' }
FOBlockParser class >> parse: aString [
	^ self new parse: aString
]

{ #category : #'private - parsing' }
FOBlockParser >> addChild: aBlockNode [
	[ tip canContain: aBlockNode ] whileFalse: [ self finalizeBlock: tip ].
	aBlockNode startLine: lineNumber.
	tip addChild: aBlockNode.
	tip := aBlockNode.
	^ aBlockNode
]

{ #category : #'private - parsing' }
FOBlockParser >> addLine [
	tip appendLine: scanner remainingContent
]

{ #category : #'private - parsing' }
FOBlockParser >> addRemainderOfLineTo: aContainer [
	| container blankValue cursor |
	container := aContainer.
	(allClosed not and: [ scanner isBlank not and: [ tip isParagraph ] ])
		ifTrue: [ ^ self addLine ].
	self closeUnmatchedBlocks.
	(scanner isBlank and: [ container lastChild notNil ])
		ifTrue: [ container lastChild lastLineBlank: true ].
	blankValue := scanner isBlank and: [ (container absorbsBlankLine: lineNumber) not ].
	cursor := container.
	[ cursor notNil ] whileTrue: [
		cursor lastLineBlank: blankValue.
		cursor := cursor parent ].
	container acceptsLines
		ifTrue: [
			self addLine.
			container checkCloseOn: self ]
		ifFalse: [
			(scanner offset < scanner line size and: [ scanner isBlank not ])
				ifTrue: [
					self addChild: FOParagraph new.
					scanner advanceNextNonspace.
					self addLine ] ]
]

{ #category : #'private - parsing' }
FOBlockParser >> blockStartSelectors [
	^ #( tryBlockquoteStart: tryAtxHeadingStart: tryFencedCodeStart: tryHtmlBlockStart:
	trySetextHeadingStart: tryThematicBreakStart: tryListItemStart: tryIndentedCodeStart: )
]

{ #category : #'private - parsing' }
FOBlockParser >> closeUnmatchedBlocks [
	allClosed ifTrue: [ ^ self ].
	[ oldTip ~~ lastMatchedContainer ] whileTrue: [
		| above |
		above := oldTip parent.
		self finalizeBlock: oldTip.
		oldTip := above ].
	allClosed := true
]

{ #category : #'private - parsing' }
FOBlockParser >> collectBlocksOf: aBlock into: aCollection [
	aCollection add: aBlock.
	aBlock children do: [ :each |
		each isBlock ifTrue: [ self collectBlocksOf: each into: aCollection ] ]
]

{ #category : #'link references' }
FOBlockParser >> consumeLinkReferenceFrom: aString [
	"Answer how many characters of aString a link reference definition takes, and
	 register it with the document. Answers 0 when there is none."
	^ inlineParser parseLinkReferenceIn: aString
]

{ #category : #'private - parsing' }
FOBlockParser >> couldStartBlock: aCharacterOrNil [
	"A cheap pre-test: no block start begins with any other character."
	aCharacterOrNil ifNil: [ ^ false ].
	^ ('#`~*+_=<>-' includes: aCharacterOrNil) or: [ aCharacterOrNil isDigit ]
]

{ #category : #accessing }
FOBlockParser >> document [
	^ document
]

{ #category : #'private - parsing' }
FOBlockParser >> finalizeBlock: aBlock [
	| above |
	above := aBlock parent.
	aBlock close.
	aBlock finalizeOn: self.
	tip := above
]

{ #category : #'private - parsing' }
FOBlockParser >> findBlockStartsFrom: aContainer [
	"Open as many new blocks as the rest of the line calls for and answer the
	 innermost one."
	| container searching result |
	container := aContainer.
	searching := (container isParagraph not and: [ container acceptsLines ]) not.
	[ searching ] whileTrue: [
		scanner findNextNonspace.
		(scanner isIndented not
			and: [ (self couldStartBlock: scanner peekAtNextNonspace) not ])
			ifTrue: [
				scanner advanceNextNonspace.
				searching := false ]
			ifFalse: [
				result := self tryBlockStartsWith: container.
				result
					ifNil: [
						scanner advanceNextNonspace.
						searching := false ]
					ifNotNil: [
						container := tip.
						result = #leaf ifTrue: [ searching := false ] ] ] ].
	^ container
]

{ #category : #parsing }
FOBlockParser >> incorporateLine: aLine [
	| container allMatched result |
	container := document.
	oldTip := tip.
	lineNumber := lineNumber + 1.
	scanner line: (self sanitize: aLine).
	allMatched := true.
	[ allMatched and: [ container lastChild notNil and: [ container lastChild isOpen ] ] ]
		whileTrue: [
			container := container lastChild.
			scanner findNextNonspace.
			result := container continueOn: self.
			result = #lineConsumed ifTrue: [ ^ self ].
			result = #notMatched ifTrue: [
				allMatched := false.
				container := container parent ] ].
	allClosed := container == oldTip.
	lastMatchedContainer := container.
	container := self findBlockStartsFrom: container.
	self addRemainderOfLineTo: container
]

{ #category : #accessing }
FOBlockParser >> lineNumber [
	^ lineNumber
]

{ #category : #parsing }
FOBlockParser >> parse: aString [
	document := FODocument new.
	tip := document.
	lastMatchedContainer := document.
	allClosed := true.
	scanner := FOLineScanner new.
	inlineParser := FOInlineParser new document: document.
	lineNumber := 0.
	(self splitLines: aString) do: [ :each | self incorporateLine: each ].
	[ tip notNil ] whileTrue: [ self finalizeBlock: tip ].
	self processInlines.
	^ document
]

{ #category : #'private - parsing' }
FOBlockParser >> parseListMarkerIn: aContainer [
	| rest data bullet ordered markerLength nextChar spacesStartColumn spacesStartOffset spacesAfterMarker blankItem |
	scanner isIndented ifTrue: [ ^ nil ].
	rest := scanner restFromNextNonspace.
	data := FOListData new markerOffset: scanner indent; yourself.
	bullet := FOSyntax bulletMarkerIn: rest.
	bullet
		ifNotNil: [
			data ordered: false; bulletChar: bullet.
			markerLength := 1 ]
		ifNil: [
			ordered := FOSyntax orderedMarkerIn: rest.
			ordered ifNil: [ ^ nil ].
			"Only a list starting at 1 may interrupt a paragraph."
			(aContainer isParagraph and: [ ordered first ~= 1 ]) ifTrue: [ ^ nil ].
			data ordered: true; start: ordered first; delimiter: (ordered at: 2).
			markerLength := ordered at: 3 ].
	nextChar := scanner at: scanner nextNonspace + markerLength.
	(nextChar isNil or: [ FOSyntax isSpaceOrTab: nextChar ]) ifFalse: [ ^ nil ].
	"An empty item may not interrupt a paragraph either."
	(aContainer isParagraph and: [ FOSyntax isBlank: (rest allButFirst: markerLength) ])
		ifTrue: [ ^ nil ].
	scanner advanceNextNonspace.
	scanner advanceOffset: markerLength columns: true.
	spacesStartColumn := scanner column.
	spacesStartOffset := scanner offset.
	[ scanner advanceOffset: 1 columns: true.
	nextChar := scanner peek.
	scanner column - spacesStartColumn < 5 and: [ FOSyntax isSpaceOrTab: nextChar ] ]
		whileTrue.
	blankItem := scanner peek isNil.
	spacesAfterMarker := scanner column - spacesStartColumn.
	(spacesAfterMarker >= 5 or: [ spacesAfterMarker < 1 or: [ blankItem ] ])
		ifTrue: [
			"Too much or no space after the marker: the content starts one space in."
			data padding: markerLength + 1.
			scanner column: spacesStartColumn.
			scanner offset: spacesStartOffset.
			(FOSyntax isSpaceOrTab: scanner peek)
				ifTrue: [ scanner advanceOffset: 1 columns: true ] ]
		ifFalse: [ data padding: markerLength + spacesAfterMarker ].
	^ data
]

{ #category : #'private - parsing' }
FOBlockParser >> processInlines [
	| blocks |
	blocks := OrderedCollection new.
	self collectBlocksOf: document into: blocks.
	blocks do: [ :block |
		block holdsInlines
			ifTrue: [ inlineParser parse: block content trimBoth into: block ] ]
]

{ #category : #'private - parsing' }
FOBlockParser >> replace: aBlock with: anotherBlock [
	| index parentBlock |
	parentBlock := aBlock parent.
	index := parentBlock children indexOf: aBlock.
	parentBlock children at: index put: anotherBlock.
	anotherBlock parent: parentBlock.
	aBlock parent: nil
]

{ #category : #'private - lines' }
FOBlockParser >> sanitize: aLine [
	"A NUL would be unsafe in the output, so the spec replaces it."
	(aLine includes: (Character value: 0)) ifFalse: [ ^ aLine ].
	^ aLine collect: [ :each |
		each = (Character value: 0) ifTrue: [ Character value: 16rFFFD ] ifFalse: [ each ] ]
]

{ #category : #accessing }
FOBlockParser >> scanner [
	^ scanner
]

{ #category : #'private - lines' }
FOBlockParser >> splitLines: aString [
	"Split on any of the three line endings. A final line ending does not start an
	 extra empty line."
	| result current index char |
	result := OrderedCollection new.
	current := WriteStream on: String new.
	index := 1.
	[ index <= aString size ] whileTrue: [
		char := aString at: index.
		char = Character cr
			ifTrue: [
				result add: current contents.
				current := WriteStream on: String new.
				(index < aString size and: [ (aString at: index + 1) = Character lf ])
					ifTrue: [ index := index + 1 ] ]
			ifFalse: [
				char = Character lf
					ifTrue: [
						result add: current contents.
						current := WriteStream on: String new ]
					ifFalse: [ current nextPut: char ] ].
		index := index + 1 ].
	current contents ifNotEmpty: [ :line | result add: line ].
	^ result
]

{ #category : #'link references' }
FOBlockParser >> stripLinkReferencesFrom: aBlock [
	| consumed |
	[ aBlock content notEmpty
		and: [ aBlock content first = $[
		and: [ consumed := self consumeLinkReferenceFrom: aBlock content.
			consumed > 0 ] ] ]
		whileTrue: [ aBlock content: (aBlock content allButFirst: consumed) ]
]

{ #category : #'block starts' }
FOBlockParser >> tryAtxHeadingStart: aContainer [
	| rest markerLength level heading |
	scanner isIndented ifTrue: [ ^ nil ].
	rest := scanner restFromNextNonspace.
	markerLength := FOSyntax atxMarkerLengthIn: rest.
	markerLength = 0 ifTrue: [ ^ nil ].
	level := 0.
	[ level < rest size and: [ (rest at: level + 1) = $# ] ] whileTrue: [ level := level + 1 ].
	scanner advanceNextNonspace.
	scanner advanceOffset: markerLength columns: false.
	self closeUnmatchedBlocks.
	heading := self addChild: (FOHeader new level: level; yourself).
	heading content: (FOSyntax atxContentOf: scanner restOfLine).
	scanner advanceOffset: scanner line size - scanner offset columns: false.
	^ #leaf
]

{ #category : #'private - parsing' }
FOBlockParser >> tryBlockStartsWith: aContainer [
	self blockStartSelectors do: [ :selector |
		(self perform: selector with: aContainer) ifNotNil: [ :result | ^ result ] ].
	^ nil
]

{ #category : #'block starts' }
FOBlockParser >> tryBlockquoteStart: aContainer [
	(scanner isIndented not and: [ scanner peekAtNextNonspace = $> ]) ifFalse: [ ^ nil ].
	scanner advanceNextNonspace.
	scanner advanceOffset: 1 columns: false.
	(FOSyntax isSpaceOrTab: scanner peek) ifTrue: [ scanner advanceOffset: 1 columns: true ].
	self closeUnmatchedBlocks.
	self addChild: FOBlockquote new.
	^ #container
]

{ #category : #'block starts' }
FOBlockParser >> tryFencedCodeStart: aContainer [
	| rest fenceLength block |
	scanner isIndented ifTrue: [ ^ nil ].
	rest := scanner restFromNextNonspace.
	fenceLength := FOSyntax openingFenceLengthIn: rest.
	fenceLength = 0 ifTrue: [ ^ nil ].
	self closeUnmatchedBlocks.
	block := self addChild: FOFencedCodeBlock new.
	block
		fenceLength: fenceLength;
		fenceChar: rest first;
		fenceOffset: scanner indent.
	scanner advanceNextNonspace.
	scanner advanceOffset: fenceLength columns: false.
	^ #leaf
]

{ #category : #'block starts' }
FOBlockParser >> tryHtmlBlockStart: aContainer [
	| rest type canInterrupt block |
	scanner isIndented ifTrue: [ ^ nil ].
	scanner peekAtNextNonspace = $< ifFalse: [ ^ nil ].
	rest := scanner restFromNextNonspace.
	canInterrupt := aContainer isParagraph not
		and: [ (allClosed not and: [ scanner isBlank not and: [ tip isParagraph ] ]) not ].
	type := FOHtmlTagScanner htmlBlockTypeIn: rest canInterruptParagraph: canInterrupt.
	type = 0 ifTrue: [ ^ nil ].
	self closeUnmatchedBlocks.
	block := self addChild: FORawHTMLBlock new.
	block blockType: type.
	^ #leaf
]

{ #category : #'block starts' }
FOBlockParser >> tryIndentedCodeStart: aContainer [
	(scanner isIndented and: [ tip isParagraph not and: [ scanner isBlank not ] ])
		ifFalse: [ ^ nil ].
	scanner advanceOffset: 4 columns: true.
	self closeUnmatchedBlocks.
	self addChild: FOIndentedCodeBlock new.
	^ #leaf
]

{ #category : #'block starts' }
FOBlockParser >> tryListItemStart: aContainer [
	| data item |
	(scanner isIndented not or: [ aContainer isList ]) ifFalse: [ ^ nil ].
	data := self parseListMarkerIn: aContainer.
	data ifNil: [ ^ nil ].
	self closeUnmatchedBlocks.
	(tip isList and: [ aContainer isList and: [ aContainer listData matches: data ] ])
		ifFalse: [ (self addChild: FOList new) listData: data ].
	item := self addChild: FOListItem new.
	item listData: data.
	^ #container
]

{ #category : #'block starts' }
FOBlockParser >> trySetextHeadingStart: aContainer [
	| level heading |
	scanner isIndented ifTrue: [ ^ nil ].
	aContainer isParagraph ifFalse: [ ^ nil ].
	level := FOSyntax setextLevelOf: scanner restFromNextNonspace.
	level ifNil: [ ^ nil ].
	self closeUnmatchedBlocks.
	self stripLinkReferencesFrom: aContainer.
	aContainer content isEmpty ifTrue: [ ^ nil ].
	heading := FOHeader new level: level; yourself.
	heading content: aContainer content.
	heading startLine: aContainer startLine.
	self replace: aContainer with: heading.
	tip := heading.
	scanner advanceOffset: scanner line size - scanner offset columns: false.
	^ #leaf
]

{ #category : #'block starts' }
FOBlockParser >> tryThematicBreakStart: aContainer [
	scanner isIndented ifTrue: [ ^ nil ].
	(FOSyntax isThematicBreak: scanner restFromNextNonspace) ifFalse: [ ^ nil ].
	self closeUnmatchedBlocks.
	self addChild: FOThematicBreak new.
	scanner advanceOffset: scanner line size - scanner offset columns: false.
	^ #leaf
]
