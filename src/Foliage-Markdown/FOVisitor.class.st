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
