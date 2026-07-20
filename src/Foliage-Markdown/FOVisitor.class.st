Class {
	#name : #FOVisitor,
	#superclass : #Object,
	#category : #'Foliage-Markdown'
}

{ #category : #visiting }
FOVisitor >> visitDocument: aDocument [
	^ self subclassResponsibility
]

{ #category : #visiting }
FOVisitor >> visitHeader: aHeader [
	^ self subclassResponsibility
]

{ #category : #visiting }
FOVisitor >> visitParagraph: aParagraph [
	^ self subclassResponsibility
]

{ #category : #visiting }
FOVisitor >> visitCodeBlock: aCodeBlock [
	^ self subclassResponsibility
]

{ #category : #visiting }
FOVisitor >> visitBlockquote: aBlockquote [
	^ self subclassResponsibility
]

{ #category : #visiting }
FOVisitor >> visitList: aList [
	^ self subclassResponsibility
]

{ #category : #visiting }
FOVisitor >> visitListItem: aListItem [
	^ self subclassResponsibility
]

{ #category : #visiting }
FOVisitor >> visitText: aText [
	^ self subclassResponsibility
]

{ #category : #visiting }
FOVisitor >> visitBold: aBold [
	^ self subclassResponsibility
]

{ #category : #visiting }
FOVisitor >> visitItalic: anItalic [
	^ self subclassResponsibility
]

{ #category : #visiting }
FOVisitor >> visitLink: aLink [
	^ self subclassResponsibility
]

{ #category : #visiting }
FOVisitor >> visitImage: anImage [
	^ self subclassResponsibility
]
