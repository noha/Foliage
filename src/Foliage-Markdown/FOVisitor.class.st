"
Abstract superclass of the AST visitors. Every node kind has its own visit
message; subclasses implement the ones they care about.
"
Class {
	#name : #FOVisitor,
	#superclass : #Object,
	#category : #'Foliage-Markdown'
}

{ #category : #'instance creation' }
FOVisitor class >> render: aNode [
	^ aNode acceptVisitor: self new
]

{ #category : #'visiting - blocks' }
FOVisitor >> visitBlockquote: aBlockquote [
	^ self subclassResponsibility
]

{ #category : #'visiting - inlines' }
FOVisitor >> visitBold: aBold [
	^ self subclassResponsibility
]

{ #category : #'visiting - blocks' }
FOVisitor >> visitCodeBlock: aCodeBlock [
	^ self subclassResponsibility
]

{ #category : #'visiting - inlines' }
FOVisitor >> visitCodeSpan: aCodeSpan [
	^ self subclassResponsibility
]

{ #category : #'visiting - blocks' }
FOVisitor >> visitDocument: aDocument [
	^ self subclassResponsibility
]

{ #category : #'visiting - inlines' }
FOVisitor >> visitHardBreak: aHardBreak [
	^ self subclassResponsibility
]

{ #category : #'visiting - blocks' }
FOVisitor >> visitHeader: aHeader [
	^ self subclassResponsibility
]

{ #category : #'visiting - inlines' }
FOVisitor >> visitImage: anImage [
	^ self subclassResponsibility
]

{ #category : #'visiting - inlines' }
FOVisitor >> visitItalic: anItalic [
	^ self subclassResponsibility
]

{ #category : #'visiting - inlines' }
FOVisitor >> visitLink: aLink [
	^ self subclassResponsibility
]

{ #category : #'visiting - blocks' }
FOVisitor >> visitList: aList [
	^ self subclassResponsibility
]

{ #category : #'visiting - blocks' }
FOVisitor >> visitListItem: aListItem [
	^ self subclassResponsibility
]

{ #category : #'visiting - blocks' }
FOVisitor >> visitParagraph: aParagraph [
	^ self subclassResponsibility
]

{ #category : #'visiting - blocks' }
FOVisitor >> visitRawHTMLBlock: aRawHTMLBlock [
	^ self subclassResponsibility
]

{ #category : #'visiting - inlines' }
FOVisitor >> visitRawHTMLInline: aRawHTMLInline [
	^ self subclassResponsibility
]

{ #category : #'visiting - inlines' }
FOVisitor >> visitSoftBreak: aSoftBreak [
	^ self subclassResponsibility
]

{ #category : #'visiting - inlines' }
FOVisitor >> visitText: aText [
	^ self subclassResponsibility
]

{ #category : #'visiting - blocks' }
FOVisitor >> visitThematicBreak: aThematicBreak [
	^ self subclassResponsibility
]
