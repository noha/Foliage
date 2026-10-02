"
Abstract superclass of the inline nodes (text, emphasis, links, ...). Inline
nodes are produced by FOInlineParser from the raw content of a leaf block.
"
Class {
	#name : #FOInlineNode,
	#superclass : #FONode,
	#category : #'Foliage-Markdown'
}

{ #category : #testing }
FOInlineNode >> isInline [
	^ true
]
