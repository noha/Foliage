"
Renders the readable text of a document, used for things like the abstract of a
blog post. Markup, code blocks aside, contributes its text; images and raw HTML
contribute nothing.
"
Class {
	#name : #FOPlainTextVisitor,
	#superclass : #FOVisitor,
	#category : #'Foliage-Markdown'
}

{ #category : #'instance creation' }
FOPlainTextVisitor class >> render: aNode [
	^ aNode acceptVisitor: self new
]

{ #category : #'private - writing' }
FOPlainTextVisitor >> renderChildren: aNode [
	^ String streamContents: [ :out |
		aNode children do: [ :each | out nextPutAll: (each acceptVisitor: self) ] ]
]

{ #category : #'private - writing' }
FOPlainTextVisitor >> renderChildren: aNode separatedBySpace: aBoolean [
	^ String streamContents: [ :out |
		aNode children
			do: [ :each | out nextPutAll: (each acceptVisitor: self) ]
			separatedBy: [ aBoolean ifTrue: [ out nextPut: $  ] ] ]
]

{ #category : #'visiting - blocks' }
FOPlainTextVisitor >> visitBlockquote: aBlockquote [
	^ self renderChildren: aBlockquote separatedBySpace: true
]

{ #category : #'visiting - inlines' }
FOPlainTextVisitor >> visitBold: aBold [
	^ self renderChildren: aBold
]

{ #category : #'visiting - blocks' }
FOPlainTextVisitor >> visitCodeBlock: aCodeBlock [
	^ aCodeBlock code
]

{ #category : #'visiting - inlines' }
FOPlainTextVisitor >> visitCodeSpan: aCodeSpan [
	^ aCodeSpan code
]

{ #category : #'visiting - blocks' }
FOPlainTextVisitor >> visitDocument: aDocument [
	^ self renderChildren: aDocument separatedBySpace: true
]

{ #category : #'visiting - inlines' }
FOPlainTextVisitor >> visitHardBreak: aHardBreak [
	^ ' '
]

{ #category : #'visiting - blocks' }
FOPlainTextVisitor >> visitHeader: aHeader [
	^ self renderChildren: aHeader
]

{ #category : #'visiting - inlines' }
FOPlainTextVisitor >> visitImage: anImage [
	"An image has no textual content worth including in a plain-text abstract."
	^ ''
]

{ #category : #'visiting - inlines' }
FOPlainTextVisitor >> visitItalic: anItalic [
	^ self renderChildren: anItalic
]

{ #category : #'visiting - inlines' }
FOPlainTextVisitor >> visitLink: aLink [
	^ self renderChildren: aLink
]

{ #category : #'visiting - blocks' }
FOPlainTextVisitor >> visitList: aList [
	^ self renderChildren: aList separatedBySpace: true
]

{ #category : #'visiting - blocks' }
FOPlainTextVisitor >> visitListItem: aListItem [
	^ self renderChildren: aListItem separatedBySpace: true
]

{ #category : #'visiting - blocks' }
FOPlainTextVisitor >> visitParagraph: aParagraph [
	^ self renderChildren: aParagraph
]

{ #category : #'visiting - blocks' }
FOPlainTextVisitor >> visitRawHTMLBlock: aRawHTMLBlock [
	"Markup has no textual content worth including in a plain-text abstract."
	^ ''
]

{ #category : #'visiting - inlines' }
FOPlainTextVisitor >> visitRawHTMLInline: aRawHTMLInline [
	^ ''
]

{ #category : #'visiting - inlines' }
FOPlainTextVisitor >> visitSoftBreak: aSoftBreak [
	^ ' '
]

{ #category : #'visiting - inlines' }
FOPlainTextVisitor >> visitText: aText [
	^ aText string
]

{ #category : #'visiting - blocks' }
FOPlainTextVisitor >> visitThematicBreak: aThematicBreak [
	^ ''
]
