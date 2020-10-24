Class {
	#name : #FOPillarVisitor,
	#superclass : #PRVisitor,
	#category : #'Foliage-Core-Visitor'
}

{ #category : #visiting }
FOPillarVisitor >> visit: anObject [
	^ anObject accept: self
]
