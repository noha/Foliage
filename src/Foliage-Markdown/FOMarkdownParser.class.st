"
The entry point of the markdown package: FOMarkdownParser parse: aString answers
the FODocument for a markdown source.

Parsing follows CommonMark and runs in two phases - FOBlockParser reads the block
structure line by line, FOInlineParser then turns the text of the leaf blocks
into inline nodes. Render the result with FOHTMLRenderVisitor or
FOPlainTextVisitor.
"
Class {
	#name : #FOMarkdownParser,
	#superclass : #Object,
	#category : #'Foliage-Markdown'
}

{ #category : #parsing }
FOMarkdownParser class >> parse: aString [
	^ self new parse: aString
]

{ #category : #parsing }
FOMarkdownParser >> parse: aString [
	^ FOBlockParser new parse: aString
]
