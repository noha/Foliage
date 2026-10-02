"
Emphasis, written with * or _. Its children are inline nodes, so emphasis can be
nested and can contain links.
"
Class {
	#name : #FOItalic,
	#superclass : #FOInlineNode,
	#category : #'Foliage-Markdown'
}

{ #category : #visiting }
FOItalic >> acceptVisitor: aVisitor [
	^ aVisitor visitItalic: self
]
