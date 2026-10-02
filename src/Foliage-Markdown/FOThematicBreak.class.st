"
A thematic break: a line of three or more *, - or _, rendered as <hr />.
"
Class {
	#name : #FOThematicBreak,
	#superclass : #FOBlockNode,
	#category : #'Foliage-Markdown'
}

{ #category : #visiting }
FOThematicBreak >> acceptVisitor: aVisitor [
	^ aVisitor visitThematicBreak: self
]
