Class {
	#name : #FOHTMLRenderVisitorTest,
	#superclass : #TestCase,
	#category : #'Foliage-Markdown-Tests'
}

{ #category : #private }
FOHTMLRenderVisitorTest >> nl [
	^ String with: Character lf
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderHeader [
	| html |
	html := FOHTMLRenderVisitor render: (FOHeader new level: 2; text: 'Hi'; yourself).
	self assert: html equals: '<h2>Hi</h2>'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderParagraph [
	| html |
	html := FOHTMLRenderVisitor render: (FOParagraph new text: 'plain text'; yourself).
	self assert: html equals: '<p>plain text</p>'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderParagraphEscapesHtml [
	| html |
	html := FOHTMLRenderVisitor render: (FOParagraph new text: 'Hello & <world>'; yourself).
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
	quote := FOBlockquote new text: 'This is a quote'; yourself.
	html := FOHTMLRenderVisitor render: quote.
	self assert: html equals: '<blockquote>This is a quote</blockquote>'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderBlockquoteMultiLineUsesBr [
	| html quote |
	quote := FOBlockquote new text: 'line one', self nl, 'line two'; yourself.
	html := FOHTMLRenderVisitor render: quote.
	self assert: html equals: '<blockquote>line one<br>', self nl, 'line two</blockquote>'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderBlockquoteEscapesHtml [
	| html quote |
	quote := FOBlockquote new text: '<div>&x</div>'; yourself.
	html := FOHTMLRenderVisitor render: quote.
	self assert: html equals: '<blockquote>&lt;div&gt;&amp;x&lt;/div&gt;</blockquote>'
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderCodeBlockEscapesHtml [
	| html block |
	block := FOCodeBlock new kind: #fenced; language: 'html'; code: '<div>&x</div>'; yourself.
	html := FOHTMLRenderVisitor render: block.
	self assert: html equals: '<pre><code class="language-html">&lt;div&gt;&amp;x&lt;/div&gt;</code></pre>'
]
