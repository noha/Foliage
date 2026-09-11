"
A raw HTML tag inside a line of text, copied verbatim into the output.
"
Class {
	#name : #FORawHTMLInline,
	#superclass : #FOInlineNode,
	#instVars : [
		'html'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #visiting }
FORawHTMLInline >> acceptVisitor: aVisitor [
	^ aVisitor visitRawHTMLInline: self
]

{ #category : #accessing }
FORawHTMLInline >> html [
	^ html ifNil: [ '' ]
]

{ #category : #accessing }
FORawHTMLInline >> html: aString [
	html := aString
]
