"
A pipe table, the GitHub flavoured extension to CommonMark. While the document is
read the table collects the raw body lines; the header row and the column
alignments are taken from the lines that started it. When the table is closed the
lines are turned into FOTableRow children whose cells hold the text that is parsed
into inlines afterwards, like the content of a paragraph.

A table ends at the first blank line. Every row is fitted to the number of header
cells: missing cells are empty, surplus cells are dropped.
"
Class {
	#name : #FOTable,
	#superclass : #FOBlockNode,
	#instVars : [
		'alignments',
		'headerCells'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #visiting }
FOTable >> acceptVisitor: aVisitor [
	^ aVisitor visitTable: self
]

{ #category : #testing }
FOTable >> acceptsLines [
	^ true
]

{ #category : #accessing }
FOTable >> alignments [
	"One entry per column: #left, #center, #right or nil for no alignment."
	^ alignments
]

{ #category : #accessing }
FOTable >> alignments: anArray [
	alignments := anArray
]

{ #category : #parsing }
FOTable >> continueOn: aParser [
	^ aParser scanner isBlank
		ifTrue: [ #notMatched ]
		ifFalse: [ #matched ]
]

{ #category : #parsing }
FOTable >> finalizeOn: aParser [
	self addRowWithCells: headerCells header: true.
	(self content lines reject: [ :each | FOSyntax isBlank: each ])
		do: [ :each | self addRowWithCells: (FOSyntax tableCellsIn: each) header: false ]
]

{ #category : #accessing }
FOTable >> headerCells [
	^ headerCells
]

{ #category : #accessing }
FOTable >> headerCells: anArrayOfStrings [
	headerCells := anArrayOfStrings
]

{ #category : #private }
FOTable >> addRowWithCells: anArrayOfStrings header: aBoolean [
	| row |
	row := self addChild: (FOTableRow new header: aBoolean; yourself).
	alignments withIndexDo: [ :alignment :index |
		row addChild: (FOTableCell new
			alignment: alignment;
			content: (anArrayOfStrings at: index ifAbsent: [ '' ]);
			yourself) ]
]
