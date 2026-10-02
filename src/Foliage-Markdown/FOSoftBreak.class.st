"
The line ending between two lines of the same paragraph. Rendered as a newline,
not as a <br>.
"
Class {
	#name : #FOSoftBreak,
	#superclass : #FOInlineNode,
	#category : #'Foliage-Markdown'
}

{ #category : #visiting }
FOSoftBreak >> acceptVisitor: aVisitor [
	^ aVisitor visitSoftBreak: self
]
