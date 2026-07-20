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
