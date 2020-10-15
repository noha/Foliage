Class {
	#name : #FOHTMLVisitor,
	#superclass : #PRVisitor,
	#instVars : [
		'writer'
	],
	#category : #'Foliage-Core'
}

{ #category : #accessing }
FOHTMLVisitor >> contents [
	^ writer contents
]

{ #category : #initialization }
FOHTMLVisitor >> initialize [ 
	super initialize.
	writer := HTMLWriter new
]

{ #category : #visiting }
FOHTMLVisitor >> visit: anObject [
	^ anObject accept: self
]

{ #category : #'visiting-document' }
FOHTMLVisitor >> visitHeader: anObject [
	writer 
		writeHeaderLevel: anObject level 
		with: [ self visitDocumentGroup: anObject ]
]

{ #category : #'visiting-document' }
FOHTMLVisitor >> visitText: anObject [
	writer writeText: anObject
]
