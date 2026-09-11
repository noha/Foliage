"
Renders the plain text of an inline subtree, which is what the alt attribute of
an image is made of: text and code content survive, markup and raw HTML do not.
"
Class {
	#name : #FOAltTextVisitor,
	#superclass : #FOVisitor,
	#instVars : [
		'stream'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #'instance creation' }
FOAltTextVisitor class >> render: aNode [
	^ self new render: aNode
]

{ #category : #rendering }
FOAltTextVisitor >> render: aNode [
	stream := WriteStream on: String new.
	self renderChildren: aNode.
	^ stream contents
]

{ #category : #'private - writing' }
FOAltTextVisitor >> renderChildren: aNode [
	aNode children do: [ :each | each acceptVisitor: self ]
]

{ #category : #'visiting - inlines' }
FOAltTextVisitor >> visitBold: aBold [
	self renderChildren: aBold
]

{ #category : #'visiting - inlines' }
FOAltTextVisitor >> visitCodeSpan: aCodeSpan [
	stream nextPutAll: aCodeSpan code
]

{ #category : #'visiting - inlines' }
FOAltTextVisitor >> visitHardBreak: aHardBreak [
	stream nextPut: Character lf
]

{ #category : #'visiting - inlines' }
FOAltTextVisitor >> visitImage: anImage [
	self renderChildren: anImage
]

{ #category : #'visiting - inlines' }
FOAltTextVisitor >> visitItalic: anItalic [
	self renderChildren: anItalic
]

{ #category : #'visiting - inlines' }
FOAltTextVisitor >> visitLink: aLink [
	self renderChildren: aLink
]

{ #category : #'visiting - inlines' }
FOAltTextVisitor >> visitRawHTMLInline: aRawHTMLInline [
	"Markup contributes no text."
]

{ #category : #'visiting - inlines' }
FOAltTextVisitor >> visitSoftBreak: aSoftBreak [
	stream nextPut: Character lf
]

{ #category : #'visiting - inlines' }
FOAltTextVisitor >> visitText: aText [
	stream nextPutAll: aText string
]
