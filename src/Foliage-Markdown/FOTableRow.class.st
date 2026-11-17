"
A row of a pipe table. The first row of a table is the header row; its cells are
rendered as header cells.
"
Class {
	#name : #FOTableRow,
	#superclass : #FOBlockNode,
	#instVars : [
		'header'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #visiting }
FOTableRow >> acceptVisitor: aVisitor [
	^ aVisitor visitTableRow: self
]

{ #category : #accessing }
FOTableRow >> header: aBoolean [
	header := aBoolean
]

{ #category : #testing }
FOTableRow >> isHeader [
	^ header
]
