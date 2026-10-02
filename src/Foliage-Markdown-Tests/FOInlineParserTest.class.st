"
Checks the inline nodes the parser builds from the text of a leaf block:
emphasis, code spans, links, images, breaks and raw HTML.
"
Class {
	#name : #FOInlineParserTest,
	#superclass : #TestCase,
	#category : #'Foliage-Markdown-Tests'
}

{ #category : #private }
FOInlineParserTest >> nl [
	^ String with: Character lf
]

{ #category : #private }
FOInlineParserTest >> parse: aString [
	^ FOInlineParser parse: aString
]

{ #category : #private }
FOInlineParserTest >> textOf: aNode [
	^ FOAltTextVisitor render: aNode
]

{ #category : #tests }
FOInlineParserTest >> testPlainText [
	| nodes |
	nodes := self parse: 'just plain text'.
	self assert: nodes size equals: 1.
	self assert: (nodes first isKindOf: FOText).
	self assert: nodes first string equals: 'just plain text'
]

{ #category : #tests }
FOInlineParserTest >> testBold [
	| nodes |
	nodes := self parse: 'a **bold** word'.
	self assert: nodes size equals: 3.
	self assert: (nodes second isKindOf: FOBold).
	self assert: (self textOf: nodes second) equals: 'bold'
]

{ #category : #tests }
FOInlineParserTest >> testDoubleUnderscoreBold [
	"Real content (noha.github.io blog posts) uses __bold__ alongside **bold**."
	| nodes |
	nodes := self parse: 'a __bold__ word'.
	self assert: (nodes second isKindOf: FOBold).
	self assert: (self textOf: nodes second) equals: 'bold'
]

{ #category : #tests }
FOInlineParserTest >> testItalicWithUnderscore [
	| nodes |
	nodes := self parse: 'an _italic_ word'.
	self assert: (nodes second isKindOf: FOItalic).
	self assert: (self textOf: nodes second) equals: 'italic'
]

{ #category : #tests }
FOInlineParserTest >> testItalicWithSingleAsterisk [
	| nodes |
	nodes := self parse: 'an *italic* word'.
	self assert: (nodes second isKindOf: FOItalic).
	self assert: (self textOf: nodes second) equals: 'italic'
]

{ #category : #tests }
FOInlineParserTest >> testNestedEmphasis [
	| bold |
	bold := (self parse: '**a *b* c**') first.
	self assert: (bold isKindOf: FOBold).
	self assert: (bold children anySatisfy: [ :each | each isKindOf: FOItalic ]).
	self assert: (self textOf: bold) equals: 'a b c'
]

{ #category : #tests }
FOInlineParserTest >> testDelimiterBetweenLetterAndPunctuationDoesNotOpenEmphasis [
	"CommonMark only lets a run open emphasis when it is not followed by
	 punctuation, unless it is itself preceded by whitespace or punctuation. In
	 '(few**!!!**)' the opening ** sits between a letter and a bang, so the
	 asterisks stay literal - the old hand written parser made this bold."
	| nodes |
	nodes := self parse: '(few**!!!**)'.
	self assert: (nodes noneSatisfy: [ :each | each isKindOf: FOBold ]).
	self assert: (self textOf: (FOParagraph new children: nodes; yourself))
		equals: '(few**!!!**)'
]

{ #category : #tests }
FOInlineParserTest >> testEmphasisOpensAfterPunctuation [
	| nodes |
	nodes := self parse: '(**few**)'.
	self assert: (nodes anySatisfy: [ :each | each isKindOf: FOBold ])
]

{ #category : #tests }
FOInlineParserTest >> testCodeSpan [
	| nodes |
	nodes := self parse: 'a `b + c` d'.
	self assert: (nodes second isKindOf: FOCodeSpan).
	self assert: nodes second code equals: 'b + c'
]

{ #category : #tests }
FOInlineParserTest >> testCodeSpanIsNotInlineParsed [
	| span |
	span := (self parse: '`**not bold**`') first.
	self assert: (span isKindOf: FOCodeSpan).
	self assert: span code equals: '**not bold**'
]

{ #category : #tests }
FOInlineParserTest >> testBackslashEscapeKeepsCharacterLiteral [
	| nodes |
	nodes := self parse: 'a \*not emphasis\* b'.
	self assert: (nodes noneSatisfy: [ :each | each isKindOf: FOItalic ]).
	self assert: (self textOf: (FOParagraph new children: nodes; yourself))
		equals: 'a *not emphasis* b'
]

{ #category : #tests }
FOInlineParserTest >> testEntityIsResolved [
	| nodes |
	nodes := self parse: 'caf&eacute;'.
	self assert: (self textOf: (FOParagraph new children: nodes; yourself)) equals: 'café'
]

{ #category : #tests }
FOInlineParserTest >> testHttpLink [
	| link |
	link := (self parse: '[A text](http://a.link.to)') first.
	self assert: (link isKindOf: FOLink).
	self assert: link url equals: 'http://a.link.to'.
	self assert: (self textOf: link) equals: 'A text'
]

{ #category : #tests }
FOInlineParserTest >> testSiteSchemeLink [
	| link |
	link := (self parse: '[Structure](site:foo:test)') first.
	self assert: (link isKindOf: FOLink).
	self assert: link url equals: 'site:foo:test'
]

{ #category : #tests }
FOInlineParserTest >> testMailtoLink [
	| link |
	link := (self parse: '[mail](mailto:user@domain.com)') first.
	self assert: (link isKindOf: FOLink).
	self assert: link url equals: 'mailto:user@domain.com'
]

{ #category : #tests }
FOInlineParserTest >> testEmailAutolink [
	| link |
	link := (self parse: '<user@domain.com>') first.
	self assert: (link isKindOf: FOLink).
	self assert: link url equals: 'mailto:user@domain.com'
]

{ #category : #tests }
FOInlineParserTest >> testLinkTextIsParsedRecursively [
	| link |
	link := (self parse: '[**bold** text](http://x.test)') first.
	self assert: (link isKindOf: FOLink).
	self assert: (link children first isKindOf: FOBold).
	self assert: (self textOf: link) equals: 'bold text'
]

{ #category : #tests }
FOInlineParserTest >> testImageWithoutAttribute [
	| image |
	image := (self parse: '![alt](/images/x.png)') first.
	self assert: (image isKindOf: FOImage).
	self assert: image src equals: '/images/x.png'.
	self assert: (self textOf: image) equals: 'alt'.
	self assert: image attributes isEmpty
]

{ #category : #tests }
FOInlineParserTest >> testImageWithAttribute [
	"Foliage's own extension: HTML attributes after the destination."
	| image |
	image := (self parse: '![alt text](/images/IMG_9474.jpeg class=u-max-full-width)') first.
	self assert: (image isKindOf: FOImage).
	self assert: image src equals: '/images/IMG_9474.jpeg'.
	self assert: (self textOf: image) equals: 'alt text'.
	self assert: (image attributes at: #class) equals: 'u-max-full-width'
]

{ #category : #tests }
FOInlineParserTest >> testRawHtmlInline [
	| nodes |
	nodes := self parse: 'a <b>bold</b> word'.
	self assert: (nodes second isKindOf: FORawHTMLInline).
	self assert: nodes second html equals: '<b>'
]

{ #category : #tests }
FOInlineParserTest >> testSoftBreakBetweenLines [
	| nodes |
	nodes := self parse: 'one' , self nl , 'two'.
	self assert: (nodes second isKindOf: FOSoftBreak)
]

{ #category : #tests }
FOInlineParserTest >> testHardBreakFromTrailingSpaces [
	| nodes |
	nodes := self parse: 'one  ' , self nl , 'two'.
	self assert: (nodes second isKindOf: FOHardBreak).
	self assert: nodes first string equals: 'one'
]

{ #category : #tests }
FOInlineParserTest >> testMultiConstructParagraph [
	| nodes |
	nodes := self parse: 'Some **bold** and _italic_ and a [link](http://x.test) too'.
	self assert: (nodes anySatisfy: [ :each | each isKindOf: FOBold ]).
	self assert: (nodes anySatisfy: [ :each | each isKindOf: FOItalic ]).
	self assert: (nodes anySatisfy: [ :each | each isKindOf: FOLink ])
]
