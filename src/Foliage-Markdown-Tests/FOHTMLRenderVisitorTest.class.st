Class {
	#name : #FOHTMLRenderVisitorTest,
	#superclass : #TestCase,
	#category : #'Foliage-Markdown-Tests'
}

{ #category : #private }
FOHTMLRenderVisitorTest >> nl [
	^ String with: Character lf
]

{ #category : #private }
FOHTMLRenderVisitorTest >> textChildren: aString [
	^ OrderedCollection with: (FOText new string: aString; yourself)
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderHeader [
	| html |
	html := FOHTMLRenderVisitor render: (FOHeader new level: 2; children: (self textChildren: 'Hi'); yourself).
	self assert: html equals: '<h2>Hi</h2>'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderParagraph [
	| html |
	html := FOHTMLRenderVisitor render: (FOParagraph new children: (self textChildren: 'plain text'); yourself).
	self assert: html equals: '<p>plain text</p>'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderParagraphEscapesHtml [
	| html |
	html := FOHTMLRenderVisitor render: (FOParagraph new children: (self textChildren: 'Hello & <world>'); yourself).
	self assert: html equals: '<p>Hello &amp; &lt;world&gt;</p>'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderDocumentJoinsChildrenWithNewline [
	| doc html |
	doc := FOMarkdownParser parse: '# Title', self nl, self nl, 'Body text.'.
	html := FOHTMLRenderVisitor render: doc.
	self assert: html equals: '<h1>Title</h1>', self nl, '<p>Body text.</p>'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderCodeBlockWithLanguage [
	| html block |
	block := FOCodeBlock new kind: #fenced; language: 'smalltalk'; code: 'foo bar'; yourself.
	html := FOHTMLRenderVisitor render: block.
	self assert: html equals: '<pre><code class="language-smalltalk">foo bar</code></pre>'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderCodeBlockWithoutLanguage [
	| html block |
	block := FOCodeBlock new kind: #indented; language: nil; code: 'foo bar'; yourself.
	html := FOHTMLRenderVisitor render: block.
	self assert: html equals: '<pre><code>foo bar</code></pre>'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderBlockquoteSingleLine [
	| html quote |
	quote := FOBlockquote new children: (self textChildren: 'This is a quote'); yourself.
	html := FOHTMLRenderVisitor render: quote.
	self assert: html equals: '<blockquote>This is a quote</blockquote>'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderBlockquoteMultiLineUsesBr [
	| html quote |
	quote := FOBlockquote new children: (self textChildren: 'line one', self nl, 'line two'); yourself.
	html := FOHTMLRenderVisitor render: quote.
	self assert: html equals: '<blockquote>line one<br>', self nl, 'line two</blockquote>'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderBlockquoteEscapesHtml [
	| html quote |
	quote := FOBlockquote new children: (self textChildren: '<div>&x</div>'); yourself.
	html := FOHTMLRenderVisitor render: quote.
	self assert: html equals: '<blockquote>&lt;div&gt;&amp;x&lt;/div&gt;</blockquote>'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderUnorderedList [
	| doc html |
	doc := FOMarkdownParser parse: '- A', self nl, '- B'.
	html := FOHTMLRenderVisitor render: doc.
	self assert: html equals: '<ul><li>A</li><li>B</li></ul>'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderOrderedList [
	| doc html |
	doc := FOMarkdownParser parse: '1. first', self nl, '2. second'.
	html := FOHTMLRenderVisitor render: doc.
	self assert: html equals: '<ol><li>first</li><li>second</li></ol>'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderListItemEscapesHtml [
	| html item |
	item := FOListItem new children: (self textChildren: 'a & b'); yourself.
	html := FOHTMLRenderVisitor render: item.
	self assert: html equals: '<li>a &amp; b</li>'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderCodeBlockEscapesHtml [
	| html block |
	block := FOCodeBlock new kind: #fenced; language: 'html'; code: '<div>&x</div>'; yourself.
	html := FOHTMLRenderVisitor render: block.
	self assert: html equals: '<pre><code class="language-html">&lt;div&gt;&amp;x&lt;/div&gt;</code></pre>'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderBold [
	| html |
	html := FOHTMLRenderVisitor render: (FOBold new text: 'strong'; yourself).
	self assert: html equals: '<strong>strong</strong>'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderItalic [
	| html |
	html := FOHTMLRenderVisitor render: (FOItalic new text: 'em'; yourself).
	self assert: html equals: '<em>em</em>'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderLink [
	| html |
	html := FOHTMLRenderVisitor render: (FOLink new text: 'A text'; url: 'http://a.link.to'; yourself).
	self assert: html equals: '<a href="http://a.link.to">A text</a>'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderImageWithAttributes [
	| html image |
	image := FOImage new alt: 'Foliage'; src: '/images/foliage-banner.jpg'; attributes: (Dictionary new at: #class put: 'u-full-width'; yourself); yourself.
	html := FOHTMLRenderVisitor render: image.
	self assert: html equals: '<img src="/images/foliage-banner.jpg" alt="Foliage" class="u-full-width">'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderImageWithoutAttributes [
	| html image |
	image := FOImage new alt: 'plain'; src: '/images/x.png'; yourself.
	html := FOHTMLRenderVisitor render: image.
	self assert: html equals: '<img src="/images/x.png" alt="plain">'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderParagraphWithMixedInlineContent [
	| doc html |
	doc := FOMarkdownParser parse: 'Text can also contain some **bold**.'.
	html := FOHTMLRenderVisitor render: doc.
	self assert: html equals: '<p>Text can also contain some <strong>bold</strong>.</p>'
]
