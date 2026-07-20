Class {
	#name : #FOMarkdownBlockParserTest,
	#superclass : #TestCase,
	#category : #'Foliage-Markdown-Tests'
}

{ #category : #private }
FOMarkdownBlockParserTest >> nl [
	^ String with: Character lf
]

{ #category : #private }
FOMarkdownBlockParserTest >> plainTextOf: aBlockNode [
	^ String streamContents: [ :s |
		aBlockNode children do: [ :child |
			(child isKindOf: FOText)
				ifTrue: [ s nextPutAll: child string ]
				ifFalse: [ s nextPutAll: child text ] ] ]
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testSingleHeader [
	| doc header |
	doc := FOMarkdownParser parse: '# Hello'.
	self assert: doc children size equals: 1.
	header := doc children first.
	self assert: (header isKindOf: FOHeader).
	self assert: header level equals: 1.
	self assert: (self plainTextOf: header) equals: 'Hello'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testHeaderLevelFour [
	| doc header |
	doc := FOMarkdownParser parse: '#### H4 header'.
	header := doc children first.
	self assert: header level equals: 4.
	self assert: (self plainTextOf: header) equals: 'H4 header'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testSingleParagraph [
	| doc paragraph |
	doc := FOMarkdownParser parse: 'just a paragraph'.
	self assert: doc children size equals: 1.
	paragraph := doc children first.
	self assert: (paragraph isKindOf: FOParagraph).
	self assert: (self plainTextOf: paragraph) equals: 'just a paragraph'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testHeaderThenParagraph [
	| doc |
	doc := FOMarkdownParser parse: '# Title', self nl, self nl, 'Some text.'.
	self assert: doc children size equals: 2.
	self assert: (doc children first isKindOf: FOHeader).
	self assert: (self plainTextOf: doc children first) equals: 'Title'.
	self assert: (doc children second isKindOf: FOParagraph).
	self assert: (self plainTextOf: doc children second) equals: 'Some text.'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testMultiLineParagraphJoinsWithSpace [
	| doc paragraph |
	doc := FOMarkdownParser parse: 'line one', self nl, 'line two'.
	paragraph := doc children first.
	self assert: (self plainTextOf: paragraph) equals: 'line one line two'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testMultipleParagraphsSeparatedByBlankLine [
	| doc |
	doc := FOMarkdownParser parse: 'first paragraph', self nl, self nl, 'second paragraph'.
	self assert: doc children size equals: 2.
	self assert: (self plainTextOf: doc children first) equals: 'first paragraph'.
	self assert: (self plainTextOf: doc children second) equals: 'second paragraph'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testFencedCodeWithLanguage [
	| doc block |
	doc := FOMarkdownParser parse: '```language=smalltalk', self nl, 'foo bar', self nl, '```'.
	self assert: doc children size equals: 1.
	block := doc children first.
	self assert: (block isKindOf: FOCodeBlock).
	self assert: block kind equals: #fenced.
	self assert: block language equals: 'smalltalk'.
	self assert: block code equals: 'foo bar'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testFencedCodeWithoutLanguage [
	| doc block |
	doc := FOMarkdownParser parse: '```', self nl, 'plain code', self nl, '```'.
	block := doc children first.
	self assert: block kind equals: #fenced.
	self assert: block language isNil.
	self assert: block code equals: 'plain code'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testFencedCodeLenientAboutMismatchedFenceLength [
	"Real content (2020-11-07_blog-navigation.md) opens with 4 backticks and closes with 3."
	| doc block |
	doc := FOMarkdownParser parse: '````language=html', self nl, '<div></div>', self nl, '```'.
	block := doc children first.
	self assert: block kind equals: #fenced.
	self assert: block language equals: 'html'.
	self assert: block code equals: '<div></div>'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testFencedCodeMultipleLines [
	| doc block |
	doc := FOMarkdownParser parse: '```', self nl, 'line one', self nl, 'line two', self nl, '```'.
	block := doc children first.
	self assert: block code equals: 'line one', self nl, 'line two'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testUnterminatedFencedCodeDoesNotCrash [
	| doc block |
	doc := FOMarkdownParser parse: '```language=smalltalk', self nl, 'no closing fence'.
	block := doc children first.
	self assert: block code equals: 'no closing fence'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testIndentedCode [
	| doc block |
	doc := FOMarkdownParser parse: '    fun no fun', self nl, '    no more fun'.
	block := doc children first.
	self assert: (block isKindOf: FOCodeBlock).
	self assert: block kind equals: #indented.
	self assert: block language isNil.
	self assert: block code equals: 'fun no fun', self nl, 'no more fun'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testBlockquoteSingleLine [
	| doc quote |
	doc := FOMarkdownParser parse: '> This is a quote'.
	self assert: doc children size equals: 1.
	quote := doc children first.
	self assert: (quote isKindOf: FOBlockquote).
	self assert: (self plainTextOf: quote) equals: 'This is a quote'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testBlockquoteMultiLinePreservesLineBreaksAndIndent [
	| doc quote expected |
	doc := FOMarkdownParser parse:
		'> /', self nl,
		'>   raw/  -> for the markdown files', self nl,
		'>   templates/ -> for keeping the layout stuff separat'.
	quote := doc children first.
	expected := '/', self nl, '  raw/  -> for the markdown files', self nl, '  templates/ -> for keeping the layout stuff separat'.
	self assert: (self plainTextOf: quote) equals: expected
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testBlockquoteWithoutSpaceAfterMarker [
	| doc quote |
	doc := FOMarkdownParser parse: '>no space'.
	quote := doc children first.
	self assert: (self plainTextOf: quote) equals: 'no space'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testBlockquoteThenParagraph [
	| doc |
	doc := FOMarkdownParser parse: '> quoted', self nl, self nl, 'after'.
	self assert: doc children size equals: 2.
	self assert: (doc children first isKindOf: FOBlockquote).
	self assert: (doc children second isKindOf: FOParagraph).
	self assert: (self plainTextOf: doc children second) equals: 'after'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testUnorderedListFlat [
	| doc list |
	doc := FOMarkdownParser parse: '- A', self nl, '- B', self nl, '- C'.
	self assert: doc children size equals: 1.
	list := doc children first.
	self assert: (list isKindOf: FOList).
	self assert: list ordered equals: false.
	self assert: list items size equals: 3.
	self assert: (list items collect: [ :i | self plainTextOf: i ]) asArray equals: #('A' 'B' 'C')
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testOrderedListFlat [
	| doc list |
	doc := FOMarkdownParser parse: '1. first', self nl, '2. second'.
	list := doc children first.
	self assert: list ordered equals: true.
	self assert: (list items collect: [ :i | self plainTextOf: i ]) asArray equals: #('first' 'second')
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testListThenParagraph [
	| doc |
	doc := FOMarkdownParser parse: '- A', self nl, '- B', self nl, self nl, 'after'.
	self assert: doc children size equals: 2.
	self assert: (doc children first isKindOf: FOList).
	self assert: (doc children second isKindOf: FOParagraph).
	self assert: (self plainTextOf: doc children second) equals: 'after'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testOrderedListDoesNotMergeWithUnorderedList [
	| doc |
	doc := FOMarkdownParser parse: '- A', self nl, '1. first'.
	self assert: doc children size equals: 2.
	self assert: doc children first ordered equals: false.
	self assert: doc children second ordered equals: true
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testNestedListEndToEnd [
	"The syntax.md fixture case, through the full document parser."
	| doc list a |
	doc := FOMarkdownParser parse:
		'- A', self nl,
		'  1. first', self nl,
		'  2. second', self nl,
		'- B', self nl,
		'- C'.
	self assert: doc children size equals: 1.
	list := doc children first.
	self assert: (list isKindOf: FOList).
	a := list items first.
	self assert: a nestedList notNil.
	self assert: (a nestedList items collect: [ :i | self plainTextOf: i ]) asArray equals: #('first' 'second')
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testCodeBlockThenParagraph [
	| doc |
	doc := FOMarkdownParser parse: '```', self nl, 'code', self nl, '```', self nl, self nl, 'after'.
	self assert: doc children size equals: 2.
	self assert: (doc children first isKindOf: FOCodeBlock).
	self assert: (doc children second isKindOf: FOParagraph).
	self assert: (self plainTextOf: doc children second) equals: 'after'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testParagraphWithBold [
	| doc paragraph |
	doc := FOMarkdownParser parse: 'Text can also contain some **bold**.'.
	paragraph := doc children first.
	self assert: paragraph children size equals: 3.
	self assert: (paragraph children first isKindOf: FOText).
	self assert: paragraph children first string equals: 'Text can also contain some '.
	self assert: (paragraph children second isKindOf: FOBold).
	self assert: paragraph children second text equals: 'bold'.
	self assert: (paragraph children third isKindOf: FOText).
	self assert: paragraph children third string equals: '.'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testParagraphWithItalic [
	| doc paragraph |
	doc := FOMarkdownParser parse: 'some _italic_ text'.
	paragraph := doc children first.
	self assert: paragraph children size equals: 3.
	self assert: (paragraph children second isKindOf: FOItalic).
	self assert: paragraph children second text equals: 'italic'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testBoldAdjacentToPunctuationNoWhitespace [
	"Real content: 'A basic setup of the (few**!!!**) software components'"
	| doc paragraph |
	doc := FOMarkdownParser parse: '(few**!!!**) software'.
	paragraph := doc children first.
	self assert: paragraph children size equals: 3.
	self assert: paragraph children first string equals: '(few'.
	self assert: (paragraph children second isKindOf: FOBold).
	self assert: paragraph children second text equals: '!!!'.
	self assert: paragraph children third string equals: ') software'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testHttpLink [
	| doc paragraph link |
	doc := FOMarkdownParser parse: 'See [A text](http://a.link.to) here'.
	paragraph := doc children first.
	link := paragraph children detect: [ :c | c isKindOf: FOLink ].
	self assert: link text equals: 'A text'.
	self assert: link url equals: 'http://a.link.to'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testSiteSchemeLink [
	| doc paragraph link |
	doc := FOMarkdownParser parse: 'non http [Structure](site:foo:test) internal'.
	paragraph := doc children first.
	link := paragraph children detect: [ :c | c isKindOf: FOLink ].
	self assert: link text equals: 'Structure'.
	self assert: link url equals: 'site:foo:test'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testMailtoLink [
	| doc paragraph link |
	doc := FOMarkdownParser parse: '[mail](mailto:user@domain.com) us'.
	paragraph := doc children first.
	link := paragraph children detect: [ :c | c isKindOf: FOLink ].
	self assert: link text equals: 'mail'.
	self assert: link url equals: 'mailto:user@domain.com'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testInlineImageWithAttributes [
	| doc paragraph image |
	doc := FOMarkdownParser parse: 'See ![alt text](/images/IMG_9474.jpeg class=u-max-full-width) above'.
	paragraph := doc children first.
	image := paragraph children detect: [ :c | c isKindOf: FOImage ].
	self assert: image alt equals: 'alt text'.
	self assert: image src equals: '/images/IMG_9474.jpeg'.
	self assert: (image attributes at: #class) equals: 'u-max-full-width'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testInlineImageWithoutAttributes [
	| doc paragraph image |
	doc := FOMarkdownParser parse: '![plain](/images/x.png) done'.
	paragraph := doc children first.
	image := paragraph children detect: [ :c | c isKindOf: FOImage ].
	self assert: image src equals: '/images/x.png'.
	self assert: image attributes isEmpty
]
