"
Checks the block structure the parser builds: which blocks a source produces, in
which order and nested how.
"
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
FOMarkdownBlockParserTest >> parse: aString [
	^ FOMarkdownParser parse: aString
]

{ #category : #private }
FOMarkdownBlockParserTest >> lines: anArrayOfLines [
	^ String streamContents: [ :out |
		anArrayOfLines do: [ :each | out nextPutAll: each; nextPut: Character lf ] ]
]

{ #category : #private }
FOMarkdownBlockParserTest >> textOf: aNode [
	^ FOPlainTextVisitor render: aNode
]

{ #category : #private }
FOMarkdownBlockParserTest >> typesOf: aDocument [
	^ (aDocument children collect: [ :each | each class ]) asArray
]

{ #category : #'tests - headings' }
FOMarkdownBlockParserTest >> testAtxHeading [
	| doc |
	doc := self parse: '# H1 header'.
	self assert: (self typesOf: doc) equals: { FOHeader }.
	self assert: doc children first level equals: 1.
	self assert: (self textOf: doc children first) equals: 'H1 header'
]

{ #category : #'tests - headings' }
FOMarkdownBlockParserTest >> testAtxHeadingLevelFour [
	| doc |
	doc := self parse: '#### H4 header'.
	self assert: doc children first level equals: 4
]

{ #category : #'tests - headings' }
FOMarkdownBlockParserTest >> testSetextHeading [
	| doc |
	doc := self parse: (self lines: #( 'Title' '=====' )).
	self assert: (self typesOf: doc) equals: { FOHeader }.
	self assert: doc children first level equals: 1.
	self assert: (self textOf: doc children first) equals: 'Title'
]

{ #category : #'tests - headings' }
FOMarkdownBlockParserTest >> testHeadingThenParagraph [
	self assert: (self typesOf: (self parse: (self lines: #( '# Title' '' 'Body' ))))
		equals: { FOHeader. FOParagraph }
]

{ #category : #'tests - paragraphs' }
FOMarkdownBlockParserTest >> testSingleParagraph [
	| doc |
	doc := self parse: 'Lorem ipsum dolor sit amet.'.
	self assert: (self typesOf: doc) equals: { FOParagraph }.
	self assert: (self textOf: doc children first) equals: 'Lorem ipsum dolor sit amet.'
]

{ #category : #'tests - paragraphs' }
FOMarkdownBlockParserTest >> testMultiLineParagraphKeepsASoftBreak [
	| doc |
	doc := self parse: (self lines: #( 'line one' 'line two' )).
	self assert: (self typesOf: doc) equals: { FOParagraph }.
	self assert: (doc children first children anySatisfy: [ :each | each isKindOf: FOSoftBreak ])
]

{ #category : #'tests - paragraphs' }
FOMarkdownBlockParserTest >> testBlankLineSeparatesParagraphs [
	self assert: (self typesOf: (self parse: (self lines: #( 'first' '' 'second' ))))
		equals: { FOParagraph. FOParagraph }
]

{ #category : #'tests - paragraphs' }
FOMarkdownBlockParserTest >> testThematicBreak [
	self assert: (self typesOf: (self parse: (self lines: #( 'a' '' '---' '' 'b' ))))
		equals: { FOParagraph. FOThematicBreak. FOParagraph }
]

{ #category : #'tests - code' }
FOMarkdownBlockParserTest >> testFencedCodeWithLanguage [
	| block |
	block := (self parse: (self lines: #( '```smalltalk' '1 + 1' '```' ))) children first.
	self assert: block kind equals: #fenced.
	self assert: block language equals: 'smalltalk'.
	self assert: block code equals: '1 + 1' , self nl
]

{ #category : #'tests - code' }
FOMarkdownBlockParserTest >> testFencedCodeWithFoliageLanguageAttribute [
	| block |
	block := (self parse: (self lines: #( '```language=smalltalk' '1 + 1' '```' ))) children first.
	self assert: block language equals: 'smalltalk'
]

{ #category : #'tests - code' }
FOMarkdownBlockParserTest >> testFencedCodeWithoutLanguage [
	| block |
	block := (self parse: (self lines: #( '```' 'plain code' '```' ))) children first.
	self assert: block kind equals: #fenced.
	self assert: block language isNil
]

{ #category : #'tests - code' }
FOMarkdownBlockParserTest >> testFencedCodeClosesOnLongerFence [
	| block |
	block := (self parse: (self lines: #( '```' '<div></div>' '````' ))) children first.
	self assert: block code equals: '<div></div>' , self nl
]

{ #category : #'tests - code' }
FOMarkdownBlockParserTest >> testUnterminatedFencedCodeRunsToEndOfInput [
	| block |
	block := (self parse: (self lines: #( '```' 'no closing fence' ))) children first.
	self assert: block kind equals: #fenced.
	self assert: block code equals: 'no closing fence' , self nl
]

{ #category : #'tests - code' }
FOMarkdownBlockParserTest >> testIndentedCode [
	| block |
	block := (self parse: (self lines: #( '    fun no fun' '    no more fun' ))) children first.
	self assert: block kind equals: #indented.
	self assert: block language isNil.
	self assert: block code equals: (self lines: #( 'fun no fun' 'no more fun' ))
]

{ #category : #'tests - code' }
FOMarkdownBlockParserTest >> testCodeBlockThenParagraph [
	self assert: (self typesOf: (self parse: (self lines: #( '    code' '' 'text' ))))
		equals: { FOIndentedCodeBlock. FOParagraph }
]

{ #category : #'tests - blockquotes' }
FOMarkdownBlockParserTest >> testBlockquoteHoldsBlocks [
	| quote |
	quote := (self parse: '> This is a quote') children first.
	self assert: (quote isKindOf: FOBlockquote).
	self assert: (quote children collect: [ :each | each class ]) asArray equals: { FOParagraph }.
	self assert: (self textOf: quote) equals: 'This is a quote'
]

{ #category : #'tests - blockquotes' }
FOMarkdownBlockParserTest >> testBlockquoteWithoutSpaceAfterMarker [
	| quote |
	quote := (self parse: '>no space') children first.
	self assert: (quote isKindOf: FOBlockquote).
	self assert: (self textOf: quote) equals: 'no space'
]

{ #category : #'tests - blockquotes' }
FOMarkdownBlockParserTest >> testBlockquoteCanContainAList [
	| quote |
	quote := (self parse: (self lines: #( '> - a' '> - b' ))) children first.
	self assert: (quote children first isKindOf: FOList).
	self assert: quote children first items size equals: 2
]

{ #category : #'tests - blockquotes' }
FOMarkdownBlockParserTest >> testBlockquoteThenParagraph [
	self assert: (self typesOf: (self parse: (self lines: #( '> quoted' '' 'plain' ))))
		equals: { FOBlockquote. FOParagraph }
]

{ #category : #'tests - lists' }
FOMarkdownBlockParserTest >> testUnorderedListFlat [
	| list |
	list := (self parse: (self lines: #( '- A' '- B' '- C' ))) children first.
	self assert: list ordered equals: false.
	self assert: list tight.
	self assert: (list items collect: [ :each | self textOf: each ]) asArray equals: #( 'A' 'B' 'C' )
]

{ #category : #'tests - lists' }
FOMarkdownBlockParserTest >> testOrderedListFlat [
	| list |
	list := (self parse: (self lines: #( '1. first' '2. second' ))) children first.
	self assert: list ordered equals: true.
	self assert: list start equals: 1.
	self assert: (list items collect: [ :each | self textOf: each ]) asArray equals: #( 'first' 'second' )
]

{ #category : #'tests - lists' }
FOMarkdownBlockParserTest >> testOrderedListDoesNotMergeWithUnorderedList [
	self assert: (self typesOf: (self parse: (self lines: #( '- A' '1. first' ))))
		equals: { FOList. FOList }
]

{ #category : #'tests - lists' }
FOMarkdownBlockParserTest >> testBlankLineMakesTheListLoose [
	| list |
	list := (self parse: (self lines: #( '- A' '' '- B' ))) children first.
	self deny: list tight
]

{ #category : #'tests - lists' }
FOMarkdownBlockParserTest >> testNestedListIsABlockOfItsItem [
	| list nested |
	list := (self parse: (self lines: #( '- A' '  1. first' '  2. second' '- B' ))) children first.
	self assert: list items size equals: 2.
	nested := list items first children detect: [ :each | each isKindOf: FOList ].
	self assert: nested ordered equals: true.
	self assert: (nested items collect: [ :each | self textOf: each ]) asArray
		equals: #( 'first' 'second' ).
	self assert: (list items second children noneSatisfy: [ :each | each isKindOf: FOList ])
]

{ #category : #'tests - lists' }
FOMarkdownBlockParserTest >> testListItemCanHoldSeveralBlocks [
	| item |
	item := (self parse: (self lines: #( '- first paragraph' '' '  second paragraph' ))) children first items first.
	self assert: (item children collect: [ :each | each class ]) asArray
		equals: { FOParagraph. FOParagraph }
]

{ #category : #'tests - lists' }
FOMarkdownBlockParserTest >> testListThenParagraph [
	self assert: (self typesOf: (self parse: (self lines: #( '- A' '' 'text' ))))
		equals: { FOList. FOParagraph }
]

{ #category : #'tests - html' }
FOMarkdownBlockParserTest >> testHtmlBlockBetweenParagraphs [
	self assert: (self typesOf: (self parse: (self lines: #( 'before' '' '<div>x</div>' '' 'after' ))))
		equals: { FOParagraph. FORawHTMLBlock. FOParagraph }
]

{ #category : #'tests - html' }
FOMarkdownBlockParserTest >> testHtmlBlockKeepsLinesVerbatimWithoutInlineParsing [
	| block |
	block := (self parse: (self lines: #( '<div>' '  *not italic*' '</div>' ))) children first.
	self assert: (block isKindOf: FORawHTMLBlock).
	self assert: block html equals: (self lines: #( '<div>' '  *not italic*' '</div>' )) trimRight
]

{ #category : #'tests - html' }
FOMarkdownBlockParserTest >> testHtmlBlockEndsAtBlankLine [
	| block |
	block := (self parse: (self lines: #( '<div>x</div>' '' 'after' ))) children first.
	self assert: block html equals: '<div>x</div>'
]

{ #category : #'tests - html' }
FOMarkdownBlockParserTest >> testLessThanInParagraphIsNotAnHtmlBlock [
	self assert: (self typesOf: (self parse: '5 < 3 and more text')) equals: { FOParagraph }
]

{ #category : #'tests - link references' }
FOMarkdownBlockParserTest >> testLinkReferenceDefinitionIsNotABlock [
	| doc |
	doc := self parse: (self lines: #( '[ref]: /uri "title"' '' 'See [ref].' )).
	self assert: (self typesOf: doc) equals: { FOParagraph }.
	self assert: (doc linkReferences at: 'REF') first equals: '/uri'
]

{ #category : #'tests - link references' }
FOMarkdownBlockParserTest >> testReferenceLinkResolvesToItsDefinition [
	| link |
	link := (self parse: (self lines: #( 'See [ref].' '' '[ref]: /uri' ))) children first children
		detect: [ :each | each isKindOf: FOLink ].
	self assert: link url equals: '/uri'
]
