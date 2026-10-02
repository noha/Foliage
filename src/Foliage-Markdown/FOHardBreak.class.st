"
An explicit line break, written as a backslash or as two trailing spaces at the
end of a line. Rendered as <br />.
"
Class {
	#name : #FOHardBreak,
	#superclass : #FOInlineNode,
	#category : #'Foliage-Markdown'
}

{ #category : #visiting }
FOHardBreak >> acceptVisitor: aVisitor [
	^ aVisitor visitHardBreak: self
]
