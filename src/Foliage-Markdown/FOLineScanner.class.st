"
Keeps the position of the block parser inside the line it is currently reading.

Two positions are tracked: #offset counts characters consumed and #column counts
the screen columns they occupy, which differ as soon as tabs are involved - a tab
advances to the next multiple of four. A tab that is only partly consumed by a
container marker is remembered in #partiallyConsumedTab so the rest of it still
counts as indentation for the content.
"
Class {
	#name : #FOLineScanner,
	#superclass : #Object,
	#instVars : [
		'line',
		'offset',
		'column',
		'nextNonspace',
		'nextNonspaceColumn',
		'indent',
		'blank',
		'partiallyConsumedTab'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #scanning }
FOLineScanner >> advanceNextNonspace [
	offset := nextNonspace.
	column := nextNonspaceColumn.
	partiallyConsumedTab := false
]

{ #category : #scanning }
FOLineScanner >> advanceOffset: aCount columns: countColumns [
	"Move forward by aCount characters, or by aCount columns when countColumns is
	 true - which matters only for tabs."
	| count char charsToTab charsToAdvance |
	count := aCount.
	[ count > 0 and: [ offset < line size ] ] whileTrue: [
		char := line at: offset + 1.
		char = Character tab
			ifTrue: [
				charsToTab := 4 - (column \\ 4).
				countColumns
					ifTrue: [
						partiallyConsumedTab := charsToTab > count.
						charsToAdvance := charsToTab min: count.
						column := column + charsToAdvance.
						partiallyConsumedTab ifFalse: [ offset := offset + 1 ].
						count := count - charsToAdvance ]
					ifFalse: [
						partiallyConsumedTab := false.
						column := column + charsToTab.
						offset := offset + 1.
						count := count - 1 ] ]
			ifFalse: [
				partiallyConsumedTab := false.
				offset := offset + 1.
				column := column + 1.
				count := count - 1 ] ]
]

{ #category : #reading }
FOLineScanner >> at: anIndex [
	"Answer the character at the given zero based offset, or nil past the end."
	^ (anIndex >= 0 and: [ anIndex < line size ])
		ifTrue: [ line at: anIndex + 1 ]
		ifFalse: [ nil ]
]

{ #category : #accessing }
FOLineScanner >> column [
	^ column
]

{ #category : #accessing }
FOLineScanner >> column: anInteger [
	column := anInteger
]

{ #category : #scanning }
FOLineScanner >> findNextNonspace [
	| i cols char |
	i := offset.
	cols := column.
	[ i < line size
		and: [ char := line at: i + 1.
			char = $  or: [ char = Character tab ] ] ]
		whileTrue: [
			char = $ 
				ifTrue: [ cols := cols + 1 ]
				ifFalse: [ cols := cols + (4 - (cols \\ 4)) ].
			i := i + 1 ].
	blank := i >= line size.
	nextNonspace := i.
	nextNonspaceColumn := cols.
	indent := nextNonspaceColumn - column
]

{ #category : #accessing }
FOLineScanner >> indent [
	^ indent
]

{ #category : #testing }
FOLineScanner >> isBlank [
	^ blank
]

{ #category : #testing }
FOLineScanner >> isIndented [
	^ indent >= 4
]

{ #category : #accessing }
FOLineScanner >> line [
	^ line
]

{ #category : #initialization }
FOLineScanner >> line: aString [
	line := aString.
	offset := 0.
	column := 0.
	blank := false.
	partiallyConsumedTab := false.
	self findNextNonspace
]

{ #category : #accessing }
FOLineScanner >> nextNonspace [
	^ nextNonspace
]

{ #category : #accessing }
FOLineScanner >> offset [
	^ offset
]

{ #category : #accessing }
FOLineScanner >> offset: anInteger [
	offset := anInteger
]

{ #category : #accessing }
FOLineScanner >> partiallyConsumedTab [
	^ partiallyConsumedTab
]

{ #category : #accessing }
FOLineScanner >> partiallyConsumedTab: aBoolean [
	partiallyConsumedTab := aBoolean
]

{ #category : #reading }
FOLineScanner >> peek [
	^ self at: offset
]

{ #category : #reading }
FOLineScanner >> peekAtNextNonspace [
	^ self at: nextNonspace
]

{ #category : #reading }
FOLineScanner >> remainingContent [
	"The text of the line that belongs to the block being filled. A tab the
	 container markers only partly consumed contributes its remaining columns as
	 spaces."
	| filler charsToTab |
	partiallyConsumedTab ifFalse: [ ^ self restOfLine ].
	charsToTab := 4 - (column \\ 4).
	filler := String new: charsToTab withAll: $ .
	^ filler , (line copyFrom: offset + 2 to: line size)
]

{ #category : #reading }
FOLineScanner >> restFromNextNonspace [
	^ line copyFrom: nextNonspace + 1 to: line size
]

{ #category : #reading }
FOLineScanner >> restOfLine [
	^ line copyFrom: offset + 1 to: line size
]
