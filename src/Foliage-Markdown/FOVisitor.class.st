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
