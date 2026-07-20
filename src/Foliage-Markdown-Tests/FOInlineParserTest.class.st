Class {
	#name : #FOInlineParserTest,
	#superclass : #TestCase,
	#category : #'Foliage-Markdown-Tests'
}

{ #category : #tests }
FOInlineParserTest >> testPlainText [
	| nodes |
	nodes := FOInlineParser parse: 'just plain text'.
	self assert: nodes size equals: 1.
	self assert: (nodes first isKindOf: FOText).
	self assert: nodes first string equals: 'just plain text'
]

{ #category : #tests }
FOInlineParserTest >> testBold [
	| nodes |
	nodes := FOInlineParser parse: 'a **bold** word'.
	self assert: nodes size equals: 3.
	self assert: nodes first string equals: 'a '.
	self assert: (nodes second isKindOf: FOBold).
	self assert: nodes second text equals: 'bold'.
	self assert: nodes third string equals: ' word'
]

{ #category : #tests }
FOInlineParserTest >> testItalic [
	| nodes |
	nodes := FOInlineParser parse: 'an _italic_ word'.
	self assert: (nodes second isKindOf: FOItalic).
	self assert: nodes second text equals: 'italic'
]

{ #category : #tests }
FOInlineParserTest >> testBoldAdjacentToPunctuationNoWhitespace [
	| nodes |
	nodes := FOInlineParser parse: '(few**!!!**)'.
	self assert: nodes size equals: 3.
	self assert: nodes first string equals: '(few'.
	self assert: (nodes second isKindOf: FOBold).
	self assert: nodes second text equals: '!!!'.
	self assert: nodes third string equals: ')'
]

{ #category : #tests }
FOInlineParserTest >> testHttpLink [
	| nodes link |
	nodes := FOInlineParser parse: '[A text](http://a.link.to)'.
	link := nodes first.
	self assert: (link isKindOf: FOLink).
	self assert: link text equals: 'A text'.
	self assert: link url equals: 'http://a.link.to'
]

{ #category : #tests }
FOInlineParserTest >> testSiteSchemeLink [
	| nodes link |
	nodes := FOInlineParser parse: '[Structure](site:foo:test)'.
	link := nodes first.
	self assert: link text equals: 'Structure'.
	self assert: link url equals: 'site:foo:test'
]

{ #category : #tests }
FOInlineParserTest >> testMailtoLink [
	| nodes link |
	nodes := FOInlineParser parse: '[mail](mailto:user@domain.com)'.
	link := nodes first.
	self assert: link text equals: 'mail'.
	self assert: link url equals: 'mailto:user@domain.com'
]

{ #category : #tests }
FOInlineParserTest >> testImageWithAttribute [
	| nodes image |
	nodes := FOInlineParser parse: '![alt text](/images/IMG_9474.jpeg class=u-max-full-width)'.
	image := nodes first.
	self assert: (image isKindOf: FOImage).
	self assert: image alt equals: 'alt text'.
	self assert: image src equals: '/images/IMG_9474.jpeg'.
	self assert: (image attributes at: #class) equals: 'u-max-full-width'
]

{ #category : #tests }
FOInlineParserTest >> testImageWithoutAttribute [
	| nodes image |
	nodes := FOInlineParser parse: '![alt](/images/x.png)'.
	image := nodes first.
	self assert: image attributes isEmpty
]

{ #category : #tests }
FOInlineParserTest >> testMultiConstructParagraph [
	| nodes |
	nodes := FOInlineParser parse: 'Some **bold** and _italic_ and a [link](http://x.test) too'.
	self assert: (nodes collect: [ :n | n class name ]) asArray
		equals: #(#FOText #FOBold #FOText #FOItalic #FOText #FOLink #FOText)
]

{ #category : #tests }
FOInlineParserTest >> testLinkTextIsNotRecursivelyParsed [
	| nodes link |
	nodes := FOInlineParser parse: '[**bold** text](http://x.test)'.
	link := nodes first.
	self assert: link text equals: '**bold** text'
]
