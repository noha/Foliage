Class {
	#name : #FOHTMLRenderVisitor,
	#superclass : #FOVisitor,
	#category : #'Foliage-Markdown'
}

{ #category : #'instance creation' }
FOHTMLRenderVisitor class >> render: aNode [
	^ aNode acceptVisitor: self new
]

{ #category : #visiting }
FOHTMLRenderVisitor >> visitDocument: aDocument [
	^ String streamContents: [ :s |
		aDocument children
			do: [ :child | s nextPutAll: (child acceptVisitor: self) ]
			separatedBy: [ s nextPut: Character lf ] ]
]

{ #category : #visiting }
FOHTMLRenderVisitor >> visitHeader: aHeader [
	| level |
	level := aHeader level printString.
	^ '<h', level, '>', (self renderChildren: aHeader), '</h', level, '>'
]

{ #category : #visiting }
FOHTMLRenderVisitor >> visitParagraph: aParagraph [
	^ '<p>', (self renderChildren: aParagraph), '</p>'
]

{ #category : #visiting }
FOHTMLRenderVisitor >> visitCodeBlock: aCodeBlock [
	| classAttr |
	classAttr := aCodeBlock language
		ifNil: [ '' ]
		ifNotNil: [ :lang | ' class="language-', lang, '"' ].
	^ '<pre><code', classAttr, '>', (self escapeHtml: aCodeBlock code), '</code></pre>'
]

{ #category : #visiting }
FOHTMLRenderVisitor >> visitBlockquote: aBlockquote [
	| rendered |
	rendered := self renderChildren: aBlockquote.
	rendered := rendered copyReplaceAll: (String with: Character lf) with: ('<br>', (String with: Character lf)).
	^ '<blockquote>', rendered, '</blockquote>'
]

{ #category : #visiting }
FOHTMLRenderVisitor >> visitList: aList [
	| tag itemsHtml |
	tag := aList ordered ifTrue: [ 'ol' ] ifFalse: [ 'ul' ].
	itemsHtml := String streamContents: [ :s |
		aList items do: [ :item | s nextPutAll: (item acceptVisitor: self) ] ].
	^ '<', tag, '>', itemsHtml, '</', tag, '>'
]

{ #category : #visiting }
FOHTMLRenderVisitor >> visitListItem: aListItem [
	^ '<li>', (self renderChildren: aListItem), '</li>'
]

{ #category : #visiting }
FOHTMLRenderVisitor >> visitText: aText [
	^ self escapeHtml: aText string
]

{ #category : #visiting }
FOHTMLRenderVisitor >> visitBold: aBold [
	^ '<strong>', (self escapeHtml: aBold text), '</strong>'
]

{ #category : #visiting }
FOHTMLRenderVisitor >> visitItalic: anItalic [
	^ '<em>', (self escapeHtml: anItalic text), '</em>'
]

{ #category : #visiting }
FOHTMLRenderVisitor >> visitLink: aLink [
	^ '<a href="', (self escapeHtml: aLink url), '">', (self escapeHtml: aLink text), '</a>'
]

{ #category : #visiting }
FOHTMLRenderVisitor >> visitImage: anImage [
	| attrs |
	attrs := String streamContents: [ :s |
		anImage attributes keysAndValuesDo: [ :k :v |
			s nextPutAll: ' ', k asString, '="', (self escapeHtml: v), '"' ] ].
	^ '<img src="', (self escapeHtml: anImage src), '" alt="', (self escapeHtml: anImage alt), '"', attrs, '>'
]

{ #category : #private }
FOHTMLRenderVisitor >> renderChildren: aBlockNode [
	^ String streamContents: [ :s |
		aBlockNode children do: [ :child | s nextPutAll: (child acceptVisitor: self) ] ]
]

{ #category : #private }
FOHTMLRenderVisitor >> escapeHtml: aString [
	| result |
	result := aString copyReplaceAll: '&' with: '&amp;'.
	result := result copyReplaceAll: '<' with: '&lt;'.
	result := result copyReplaceAll: '>' with: '&gt;'.
	^ result
]
