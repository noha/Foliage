"
Strong emphasis, written with ** or __. Its children are inline nodes, so
emphasis can be nested and can contain links.
"
Class {
	#name : #FOBold,
	#superclass : #FOInlineNode,
	#category : #'Foliage-Markdown'
}

{ #category : #visiting }
FOBold >> acceptVisitor: aVisitor [
	^ aVisitor visitBold: self
]
