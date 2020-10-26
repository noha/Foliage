Class {
	#name : #FOPillarRewriteVisitor,
	#superclass : #FOPillarVisitor,
	#category : #'Foliage-Core-Visitor'
}

{ #category : #'visiting-document' }
FOPillarRewriteVisitor >> visitDocumentGroup: anObject [
	^(self visitAll: anObject children)
		ifNotEmpty: [ :c | anObject setChildren: c; yourself ]
		ifEmpty: [ nil ] 
	

]

{ #category : #'visiting-document' }
FOPillarRewriteVisitor >> visitDocumentItem: aDocumentItem [ 
	^ aDocumentItem copy
]
