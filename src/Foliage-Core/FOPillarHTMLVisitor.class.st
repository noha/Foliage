Class {
	#name : #FOPillarHTMLVisitor,
	#superclass : #PRVisitor,
	#instVars : [
		'writer'
	],
	#category : #'Foliage-Core'
}

{ #category : #accessing }
FOPillarHTMLVisitor >> contents [
	^ writer contents
]

{ #category : #initialization }
FOPillarHTMLVisitor >> initialize [ 
	super initialize.
	writer := HTMLWriter new
]

{ #category : #visiting }
FOPillarHTMLVisitor >> start: anObject [
	| result |
	result := self visit: anObject.
	writer flush.
	^ result
]

{ #category : #accessing }
FOPillarHTMLVisitor >> stream: aStream [ 
	writer stream: aStream
]

{ #category : #visiting }
FOPillarHTMLVisitor >> visit: anObject [
	^ anObject accept: self
]

{ #category : #'visiting-document' }
FOPillarHTMLVisitor >> visitHeader: anObject [
	writer 
		writeHeaderLevel: anObject level 
		with: [ self visitDocumentGroup: anObject ]
]

{ #category : #'visiting-document' }
FOPillarHTMLVisitor >> visitText: anObject [
	writer writeText: anObject
]
