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
