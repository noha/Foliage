Class {
	#name : #FOMarkdownBlockParserTest,
	#superclass : #TestCase,
	#category : #'Foliage-Markdown-Tests'
}

{ #category : #private }
FOMarkdownBlockParserTest >> nl [
	^ String with: Character lf
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testSingleHeader [
	| doc header |
	doc := FOMarkdownParser parse: '# Hello'.
	self assert: doc children size equals: 1.
	header := doc children first.
	self assert: (header isKindOf: FOHeader).
	self assert: header level equals: 1.
	self assert: header text equals: 'Hello'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testHeaderLevelFour [
	| doc header |
	doc := FOMarkdownParser parse: '#### H4 header'.
	header := doc children first.
	self assert: header level equals: 4.
	self assert: header text equals: 'H4 header'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testSingleParagraph [
	| doc paragraph |
	doc := FOMarkdownParser parse: 'just a paragraph'.
	self assert: doc children size equals: 1.
	paragraph := doc children first.
	self assert: (paragraph isKindOf: FOParagraph).
	self assert: paragraph text equals: 'just a paragraph'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testHeaderThenParagraph [
	| doc |
	doc := FOMarkdownParser parse: '# Title', self nl, self nl, 'Some text.'.
	self assert: doc children size equals: 2.
	self assert: (doc children first isKindOf: FOHeader).
	self assert: doc children first text equals: 'Title'.
	self assert: (doc children second isKindOf: FOParagraph).
	self assert: doc children second text equals: 'Some text.'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testMultiLineParagraphJoinsWithSpace [
	| doc paragraph |
	doc := FOMarkdownParser parse: 'line one', self nl, 'line two'.
	paragraph := doc children first.
	self assert: paragraph text equals: 'line one line two'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testMultipleParagraphsSeparatedByBlankLine [
	| doc |
	doc := FOMarkdownParser parse: 'first paragraph', self nl, self nl, 'second paragraph'.
	self assert: doc children size equals: 2.
	self assert: doc children first text equals: 'first paragraph'.
	self assert: doc children second text equals: 'second paragraph'
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
	self assert: quote text equals: 'This is a quote'
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
	self assert: quote text equals: expected
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testBlockquoteWithoutSpaceAfterMarker [
	| doc quote |
	doc := FOMarkdownParser parse: '>no space'.
	quote := doc children first.
	self assert: quote text equals: 'no space'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testBlockquoteThenParagraph [
	| doc |
	doc := FOMarkdownParser parse: '> quoted', self nl, self nl, 'after'.
	self assert: doc children size equals: 2.
	self assert: (doc children first isKindOf: FOBlockquote).
	self assert: (doc children second isKindOf: FOParagraph).
	self assert: doc children second text equals: 'after'
]

{ #category : #tests }
FOMarkdownBlockParserTest >> testCodeBlockThenParagraph [
	| doc |
	doc := FOMarkdownParser parse: '```', self nl, 'code', self nl, '```', self nl, self nl, 'after'.
	self assert: doc children size equals: 2.
	self assert: (doc children first isKindOf: FOCodeBlock).
	self assert: (doc children second isKindOf: FOParagraph).
	self assert: doc children second text equals: 'after'
]
