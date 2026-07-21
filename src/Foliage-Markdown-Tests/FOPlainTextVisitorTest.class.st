Class {
	#name : #FOPlainTextVisitorTest,
	#superclass : #TestCase,
	#category : #'Foliage-Markdown-Tests'
}

{ #category : #private }
FOPlainTextVisitorTest >> nl [
	^ String with: Character lf
]

{ #category : #private }
FOPlainTextVisitorTest >> plainTextOf: aString [
	^ FOPlainTextVisitor render: (FOMarkdownParser parse: aString)
]

{ #category : #tests }
FOPlainTextVisitorTest >> testHeaderAndParagraph [
	self assert: (self plainTextOf: '# Title', self nl, self nl, 'Body text.')
		equals: 'Title Body text.'
]

{ #category : #tests }
FOPlainTextVisitorTest >> testBoldAndItalicKeepOnlyTheirText [
	self assert: (self plainTextOf: 'Some **bold** and _italic_ words.')
		equals: 'Some bold and italic words.'
]

{ #category : #tests }
FOPlainTextVisitorTest >> testLinkKeepsOnlyLinkText [
	self assert: (self plainTextOf: 'See [A text](http://a.link.to) here.')
		equals: 'See A text here.'
]

{ #category : #tests }
FOPlainTextVisitorTest >> testImageContributesNothing [
	self assert: (self plainTextOf: 'Before ![alt](/x.png) after.')
		equals: 'Before  after.'
]

{ #category : #tests }
FOPlainTextVisitorTest >> testCodeBlockKeepsVerbatimCode [
	self assert: (self plainTextOf: '```', self nl, 'a + b', self nl, '```')
		equals: 'a + b'
]

{ #category : #tests }
FOPlainTextVisitorTest >> testBlockquoteKeepsItsText [
	self assert: (self plainTextOf: '> quoted text')
		equals: 'quoted text'
]

{ #category : #tests }
FOPlainTextVisitorTest >> testListJoinsItemsWithSpace [
	self assert: (self plainTextOf: '- A', self nl, '- B', self nl, '- C')
		equals: 'A B C'
]

{ #category : #tests }
FOPlainTextVisitorTest >> testComposedDocumentJoinsBlocksWithSpace [
	| text |
	text := self plainTextOf:
		'# Picking it up', self nl,
		self nl,
		'What happened so far?', self nl,
		self nl,
		'- A', self nl,
		'- B'.
	self assert: text equals: 'Picking it up What happened so far? A B'
]
