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
	^ '<h', level, '>', (self escapeHtml: aHeader text), '</h', level, '>'
]

{ #category : #visiting }
FOHTMLRenderVisitor >> visitParagraph: aParagraph [
	^ '<p>', (self escapeHtml: aParagraph text), '</p>'
]

{ #category : #visiting }
FOHTMLRenderVisitor >> visitCodeBlock: aCodeBlock [
	| classAttr |
	classAttr := aCodeBlock language
		ifNil: [ '' ]
		ifNotNil: [ :lang | ' class="language-', lang, '"' ].
	^ '<pre><code', classAttr, '>', (self escapeHtml: aCodeBlock code), '</code></pre>'
]

{ #category : #private }
FOHTMLRenderVisitor >> escapeHtml: aString [
	| result |
	result := aString copyReplaceAll: '&' with: '&amp;'.
	result := result copyReplaceAll: '<' with: '&lt;'.
	result := result copyReplaceAll: '>' with: '&gt;'.
	^ result
]
