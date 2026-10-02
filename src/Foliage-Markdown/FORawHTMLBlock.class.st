"
A block of raw HTML copied verbatim from the markdown source. Its content is
neither inline-parsed nor escaped when rendered, so authors can embed elements
the markdown syntax has no notation for (iframes, custom markup, ...).

CommonMark knows seven kinds of HTML block which differ in how they end; the
kind is remembered in #blockType so the parser can apply the right end
condition.
"
Class {
	#name : #FORawHTMLBlock,
	#superclass : #FOBlockNode,
	#instVars : [
		'html',
		'blockType'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #visiting }
FORawHTMLBlock >> acceptVisitor: aVisitor [
	^ aVisitor visitRawHTMLBlock: self
]

{ #category : #testing }
FORawHTMLBlock >> acceptsLines [
	^ true
]

{ #category : #accessing }
FORawHTMLBlock >> blockType [
	^ blockType
]

{ #category : #accessing }
FORawHTMLBlock >> blockType: anInteger [
	blockType := anInteger
]

{ #category : #parsing }
FORawHTMLBlock >> checkCloseOn: aParser [
	(self endsOnBlankLine not
		and: [ FOHtmlTagScanner line: aParser scanner remainingContent closesHtmlBlockType: blockType ])
		ifTrue: [ aParser finalizeBlock: self ]
]

{ #category : #parsing }
FORawHTMLBlock >> continueOn: aParser [
	^ (aParser scanner isBlank and: [ self endsOnBlankLine ])
		ifTrue: [ #notMatched ]
		ifFalse: [ #matched ]
]

{ #category : #testing }
FORawHTMLBlock >> endsOnBlankLine [
	"Kinds 6 and 7 are the ones ended by a blank line; the others run until their
	 own closing condition is seen."
	^ blockType >= 6
]

{ #category : #parsing }
FORawHTMLBlock >> finalizeOn: aParser [
	html := FOSyntax stripTrailingBlankLines: self content
]

{ #category : #accessing }
FORawHTMLBlock >> html [
	^ html ifNil: [ '' ]
]

{ #category : #accessing }
FORawHTMLBlock >> html: aString [
	html := aString
]
