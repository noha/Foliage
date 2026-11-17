"
A cell of a pipe table. Its text is parsed into inlines after the block structure
is known, like the content of a paragraph.
"
Class {
	#name : #FOTableCell,
	#superclass : #FOBlockNode,
	#instVars : [
		'alignment'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #visiting }
FOTableCell >> acceptVisitor: aVisitor [
	^ aVisitor visitTableCell: self
]

{ #category : #accessing }
FOTableCell >> alignment [
	"#left, #center, #right or nil when the column has no alignment."
	^ alignment
]

{ #category : #accessing }
FOTableCell >> alignment: aSymbolOrNil [
	alignment := aSymbolOrNil
]

{ #category : #testing }
FOTableCell >> holdsInlines [
	^ true
]
