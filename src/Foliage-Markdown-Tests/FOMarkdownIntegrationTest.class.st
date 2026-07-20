Class {
	#name : #FOMarkdownIntegrationTest,
	#superclass : #TestCase,
	#instVars : [
		'doc'
	],
	#category : #'Foliage-Markdown-Tests'
}

{ #category : #private }
FOMarkdownIntegrationTest >> nl [
	^ String with: Character lf
]

{ #category : #private }
FOMarkdownIntegrationTest >> syntaxMdFixture [
	"An inlined copy of noha.github.io/raw/syntax.md's examples, normalized to
	 single LF line endings (the real file mixes CR/LF/CRLF, already covered
	 separately by FOLineReader/blockquote tests) and using the space-delimited
	 image attribute syntax that is now canonical (syntax.md itself was updated
	 to match, replacing its original pipe-delimited `|class=...`)."
	^ 'title: A syntax example for testing', self nl,
		'layout: page', self nl, self nl,
		'# H1 header', self nl, self nl,
		'## H2 header', self nl, self nl,
		'Lorem ipsum dolor sit amet, consetetur sadipscing elitr.', self nl, self nl,
		'Text can also contain some _italic_', self nl,
		'Text can also contain some **bold**', self nl, self nl,
		'- A', self nl,
		'  1. first', self nl,
		'  2. second', self nl,
		'- B', self nl,
		'- C', self nl, self nl,
		'block quotes', self nl, self nl,
		'> This is a', self nl,
		'> block quote', self nl, self nl,
		'code block', self nl, self nl,
		'    fun no fun', self nl,
		'    no more fun', self nl, self nl,
		'text', self nl, self nl,
		'```', self nl,
		'Visitor>>#visitCodeblock: aCodeBlock', self nl,
		'    ^ writer', self nl,
		'        writeTag: ''pre''', self nl,
		'```', self nl, self nl,
		'Links', self nl, self nl,
		'[A text](http://a.link.to)', self nl, self nl,
		'non http', self nl, self nl,
		'[Structure](site:foo:test)', self nl, self nl,
		'internal', self nl, self nl,
		'*@a>b@*', self nl, self nl,
		'mail', self nl, self nl,
		'(mailto:user@domain.com)', self nl, self nl,
		'![alt text](/images/IMG_9474.jpeg class=u-max-full-width)'
]

{ #category : #running }
FOMarkdownIntegrationTest >> setUp [
	| frontmatter |
	super setUp.
	frontmatter := FOFrontmatterParser parse: self syntaxMdFixture.
	self assert: (frontmatter at: #title) equals: 'A syntax example for testing'.
	self assert: (frontmatter at: #layout) equals: 'page'.
	doc := FOMarkdownParser parse: frontmatter body
]

{ #category : #tests }
FOMarkdownIntegrationTest >> testTopLevelBlockCountOrderAndTypes [
	self assert: (doc children collect: [ :c | c class ]) asArray equals: {
		FOHeader. FOHeader. FOParagraph. FOParagraph. FOList. FOParagraph.
		FOBlockquote. FOParagraph. FOCodeBlock. FOParagraph. FOCodeBlock.
		FOParagraph. FOParagraph. FOParagraph. FOParagraph. FOParagraph.
		FOParagraph. FOParagraph. FOParagraph. FOParagraph }
]

{ #category : #tests }
FOMarkdownIntegrationTest >> testHeaderLevels [
	self assert: doc children first level equals: 1.
	self assert: doc children second level equals: 2
]

{ #category : #tests }
FOMarkdownIntegrationTest >> testNestedList [
	| list |
	list := doc children at: 5.
	self assert: list ordered equals: false.
	self assert: (list items collect: [ :i | i children first string ]) asArray equals: #('A' 'B' 'C').
	self assert: list items first nestedList notNil.
	self assert: list items first nestedList ordered equals: true.
	self assert: (list items first nestedList items collect: [ :i | i children first string ]) asArray
		equals: #('first' 'second').
	self assert: list items second nestedList isNil.
	self assert: list items third nestedList isNil
]

{ #category : #tests }
FOMarkdownIntegrationTest >> testBlockquote [
	| quote |
	quote := doc children at: 7.
	self assert: quote children first string equals: 'This is a', self nl, 'block quote'
]

{ #category : #tests }
FOMarkdownIntegrationTest >> testCodeBlockKindsAndLanguages [
	| codeBlocks |
	codeBlocks := doc children select: [ :c | c isKindOf: FOCodeBlock ].
	self assert: codeBlocks size equals: 2.
	self assert: codeBlocks first kind equals: #indented.
	self assert: codeBlocks first language isNil.
	self assert: codeBlocks second kind equals: #fenced.
	self assert: codeBlocks second language isNil.
	self assert: (codeBlocks second code includesSubstring: 'Visitor>>#visitCodeblock:')
]

{ #category : #tests }
FOMarkdownIntegrationTest >> testLinks [
	| httpLink siteLink |
	httpLink := (doc children at: 13) children first.
	siteLink := (doc children at: 15) children first.
	self assert: (httpLink isKindOf: FOLink).
	self assert: httpLink text equals: 'A text'.
	self assert: httpLink url equals: 'http://a.link.to'.
	self assert: (siteLink isKindOf: FOLink).
	self assert: siteLink text equals: 'Structure'.
	self assert: siteLink url equals: 'site:foo:test'
]

{ #category : #tests }
FOMarkdownIntegrationTest >> testBareMailtoIsNotLinkified [
	"Only bracketed [text](mailto:...) is a link (see FOInlineParserTest testMailtoLink) -
	 syntax.md's bare '(mailto:user@domain.com)' line has no [text] part, so it must
	 stay plain text rather than being mistaken for a link."
	| para |
	para := doc children at: 19.
	self assert: para children size equals: 1.
	self assert: (para children first isKindOf: FOText).
	self assert: para children first string equals: '(mailto:user@domain.com)'
]

{ #category : #tests }
FOMarkdownIntegrationTest >> testSingleAsteriskIsNotBold [
	| para |
	para := doc children at: 17.
	self assert: para children size equals: 1.
	self assert: (para children first isKindOf: FOText).
	self assert: para children first string equals: '*@a>b@*'
]

{ #category : #tests }
FOMarkdownIntegrationTest >> testTrailingStandaloneImage [
	| lastPara image |
	lastPara := doc children last.
	self assert: (lastPara isKindOf: FOParagraph).
	self assert: lastPara children size equals: 1.
	image := lastPara children first.
	self assert: (image isKindOf: FOImage).
	self assert: image alt equals: 'alt text'.
	self assert: image src equals: '/images/IMG_9474.jpeg'.
	self assert: (image attributes at: #class) equals: 'u-max-full-width'
]

{ #category : #tests }
FOMarkdownIntegrationTest >> testFullDocumentRendersWithoutError [
	| html |
	html := FOHTMLRenderVisitor render: doc.
	self assert: html notEmpty.
	self assert: (html includesSubstring: '<h1>H1 header</h1>').
	self assert: (html includesSubstring: '<h2>H2 header</h2>').
	self assert: (html includesSubstring: 'u-max-full-width')
]
