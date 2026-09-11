"
A block of raw HTML copied verbatim from the markdown source. It starts at a line
that looks like an HTML tag or comment and runs until the next blank line. Its
content is neither inline-parsed nor escaped when rendered, so authors can embed
elements the markdown syntax has no notation for (iframes, custom markup, ...).
"
Class {
	#name : #FORawHTMLBlock,
	#superclass : #FOBlockNode,
	#instVars : [
		'html'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #accessing }
FORawHTMLBlock >> html [
	^ html
]

{ #category : #accessing }
FORawHTMLBlock >> html: aString [
	html := aString
]

{ #category : #visiting }
FORawHTMLBlock >> acceptVisitor: aVisitor [
	^ aVisitor visitRawHTMLBlock: self
]
