"
Renders the AST as HTML, following what the CommonMark spec prescribes, down to
where the newlines go: block elements start on a fresh line, a tight list writes
its item paragraphs without <p> wrappers, and destinations are percent encoded.

Two Foliage additions survive: the attributes an author may write after an image
destination are emitted on the img element, and a fenced block's language ends up
in the usual class=""language-x"".
"
Class {
	#name : #FOHTMLRenderVisitor,
	#superclass : #FOVisitor,
	#instVars : [
		'stream',
		'lastCharacter'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #'instance creation' }
FOHTMLRenderVisitor class >> render: aNode [
	^ self new render: aNode
]

{ #category : #'private - writing' }
FOHTMLRenderVisitor >> altTextOf: anImage [
	"The alt attribute holds the plain text of the description, markup dropped."
	^ FOAltTextVisitor render: anImage
]

{ #category : #'private - escaping' }
FOHTMLRenderVisitor >> escapeHref: aString [
	"Percent encode everything a URL may not carry literally. & and ' become HTML
	 entities instead, as the reference implementation does."
	^ String streamContents: [ :out |
		aString do: [ :each |
			each = $&
				ifTrue: [ out nextPutAll: '&amp;' ]
				ifFalse: [
					each = $'
						ifTrue: [ out nextPutAll: '&#x27;' ]
						ifFalse: [
							(each isAlphaNumeric and: [ each asInteger < 128 ])
								ifTrue: [ out nextPut: each ]
								ifFalse: [
									(self hrefSafeCharacters includes: each)
										ifTrue: [ out nextPut: each ]
										ifFalse: [ self percentEncode: each on: out ] ] ] ] ] ]
]

{ #category : #'private - escaping' }
FOHTMLRenderVisitor >> escapeHtml: aString [
	^ String streamContents: [ :out |
		aString do: [ :each |
			each = $& ifTrue: [ out nextPutAll: '&amp;' ] ifFalse: [
			each = $< ifTrue: [ out nextPutAll: '&lt;' ] ifFalse: [
			each = $> ifTrue: [ out nextPutAll: '&gt;' ] ifFalse: [
			each = $" ifTrue: [ out nextPutAll: '&quot;' ] ifFalse: [
			out nextPut: each ] ] ] ] ] ]
]

{ #category : #'private - writing' }
FOHTMLRenderVisitor >> freshLine [
	"Start a new line unless the output is already at the start of one."
	(lastCharacter notNil and: [ lastCharacter ~= Character lf ])
		ifTrue: [ self newLine ]
]

{ #category : #'private - escaping' }
FOHTMLRenderVisitor >> hrefSafeCharacters [
	^ '-_.~!*''();:@&=+$,/?#%'
]

{ #category : #'private - writing' }
FOHTMLRenderVisitor >> isInTightList: aBlock [
	| item |
	item := aBlock parent.
	(item notNil and: [ item isListItem ]) ifFalse: [ ^ false ].
	^ item parent notNil and: [ item parent isList and: [ item parent tight ] ]
]

{ #category : #'private - writing' }
FOHTMLRenderVisitor >> newLine [
	self write: (String with: Character lf)
]

{ #category : #'private - escaping' }
FOHTMLRenderVisitor >> percentEncode: aCharacter on: aStream [
	(String with: aCharacter) utf8Encoded do: [ :byte |
		aStream
			nextPut: $%;
			nextPutAll: ((byte printStringBase: 16) padLeftTo: 2 with: $0) asUppercase ]
]

{ #category : #rendering }
FOHTMLRenderVisitor >> render: aNode [
	stream := WriteStream on: String new.
	lastCharacter := nil.
	aNode acceptVisitor: self.
	^ stream contents
]

{ #category : #'private - writing' }
FOHTMLRenderVisitor >> renderChildren: aNode [
	aNode children do: [ :each | each acceptVisitor: self ]
]

{ #category : #'visiting - blocks' }
FOHTMLRenderVisitor >> visitBlockquote: aBlockquote [
	self freshLine.
	self write: '<blockquote>'.
	self renderChildren: aBlockquote.
	self freshLine.
	self write: '</blockquote>'.
	self newLine
]

{ #category : #'visiting - inlines' }
FOHTMLRenderVisitor >> visitBold: aBold [
	self write: '<strong>'.
	self renderChildren: aBold.
	self write: '</strong>'
]

{ #category : #'visiting - blocks' }
FOHTMLRenderVisitor >> visitCodeBlock: aCodeBlock [
	| language |
	language := aCodeBlock language.
	self freshLine.
	self write: '<pre><code'.
	language ifNotNil: [ :each |
		self write: ' class="language-' , (self escapeHtml: each) , '"' ].
	self write: '>'.
	self write: (self escapeHtml: aCodeBlock code).
	self write: '</code></pre>'.
	self newLine
]

{ #category : #'visiting - inlines' }
FOHTMLRenderVisitor >> visitCodeSpan: aCodeSpan [
	self write: '<code>'.
	self write: (self escapeHtml: aCodeSpan code).
	self write: '</code>'
]

{ #category : #'visiting - blocks' }
FOHTMLRenderVisitor >> visitDocument: aDocument [
	self renderChildren: aDocument
]

{ #category : #'visiting - inlines' }
FOHTMLRenderVisitor >> visitHardBreak: aHardBreak [
	self write: '<br />'.
	self newLine
]

{ #category : #'visiting - blocks' }
FOHTMLRenderVisitor >> visitHeader: aHeader [
	| level |
	level := aHeader level printString.
	self freshLine.
	self write: '<h' , level , '>'.
	self renderChildren: aHeader.
	self write: '</h' , level , '>'.
	self newLine
]

{ #category : #'visiting - inlines' }
FOHTMLRenderVisitor >> visitImage: anImage [
	self write: '<img src="' , (self escapeHref: anImage src) , '"'.
	self write: ' alt="' , (self escapeHtml: (self altTextOf: anImage)) , '"'.
	anImage title ifNotNil: [ :each |
		each ifNotEmpty: [ self write: ' title="' , (self escapeHtml: each) , '"' ] ].
	anImage attributes keysAndValuesDo: [ :key :value |
		self write: ' ' , key asString , '="' , (self escapeHtml: value) , '"' ].
	self write: ' />'
]

{ #category : #'visiting - inlines' }
FOHTMLRenderVisitor >> visitItalic: anItalic [
	self write: '<em>'.
	self renderChildren: anItalic.
	self write: '</em>'
]

{ #category : #'visiting - inlines' }
FOHTMLRenderVisitor >> visitLink: aLink [
	self write: '<a href="' , (self escapeHref: aLink url) , '"'.
	aLink title ifNotNil: [ :each |
		each ifNotEmpty: [ self write: ' title="' , (self escapeHtml: each) , '"' ] ].
	self write: '>'.
	self renderChildren: aLink.
	self write: '</a>'
]

{ #category : #'visiting - blocks' }
FOHTMLRenderVisitor >> visitList: aList [
	self freshLine.
	aList ordered
		ifTrue: [
			self write: '<ol'.
			(aList start notNil and: [ aList start ~= 1 ])
				ifTrue: [ self write: ' start="' , aList start printString , '"' ].
			self write: '>' ]
		ifFalse: [ self write: '<ul>' ].
	self renderChildren: aList.
	self freshLine.
	self write: (aList ordered ifTrue: [ '</ol>' ] ifFalse: [ '</ul>' ]).
	self newLine
]

{ #category : #'visiting - blocks' }
FOHTMLRenderVisitor >> visitListItem: aListItem [
	self freshLine.
	self write: '<li>'.
	self renderChildren: aListItem.
	self write: '</li>'.
	self newLine
]

{ #category : #'visiting - blocks' }
FOHTMLRenderVisitor >> visitParagraph: aParagraph [
	| bare |
	bare := self isInTightList: aParagraph.
	bare ifFalse: [
		self freshLine.
		self write: '<p>' ].
	self renderChildren: aParagraph.
	bare ifFalse: [
		self write: '</p>'.
		self newLine ]
]

{ #category : #'visiting - blocks' }
FOHTMLRenderVisitor >> visitRawHTMLBlock: aRawHTMLBlock [
	"Deliberately not escaped: the author wrote HTML on purpose."
	self freshLine.
	self write: aRawHTMLBlock html.
	self newLine
]

{ #category : #'visiting - inlines' }
FOHTMLRenderVisitor >> visitRawHTMLInline: aRawHTMLInline [
	self write: aRawHTMLInline html
]

{ #category : #'visiting - inlines' }
FOHTMLRenderVisitor >> visitSoftBreak: aSoftBreak [
	self newLine
]

{ #category : #'visiting - inlines' }
FOHTMLRenderVisitor >> visitText: aText [
	self write: (self escapeHtml: aText string)
]

{ #category : #'visiting - blocks' }
FOHTMLRenderVisitor >> visitThematicBreak: aThematicBreak [
	self freshLine.
	self write: '<hr />'.
	self newLine
]

{ #category : #'private - writing' }
FOHTMLRenderVisitor >> write: aString [
	aString isEmpty ifTrue: [ ^ self ].
	stream nextPutAll: aString.
	lastCharacter := aString last
]
