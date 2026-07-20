Class {
	#name : #FONode,
	#superclass : #Object,
	#category : #'Foliage-Markdown'
}

{ #category : #visiting }
FONode >> acceptVisitor: aVisitor [
	^ self subclassResponsibility
]
