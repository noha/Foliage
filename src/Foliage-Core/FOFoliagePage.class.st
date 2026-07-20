Class {
	#name : #FOFoliagePage,
	#superclass : #FOPageWithMetadata,
	#instVars : [
		'document'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #visiting }
FOFoliagePage >> acceptFOVisitor: aFOVisitor [
	^ aFOVisitor visitFoliagePage: self
]

{ #category : #accessing }
FOFoliagePage >> document [
	^ document
]

{ #category : #accessing }
FOFoliagePage >> document: aFODocument [
	document := aFODocument
]

{ #category : #actions }
FOFoliagePage >> publish [
	self publishPath
		ensureDelete;
		writeStreamDo: [ :stream | stream << self htmlString ]
]

{ #category : #accessing }
FOFoliagePage >> publishPath [
	^ super publishPath withExtension: 'html'
]

{ #category : #rendering }
FOFoliagePage >> renderOn: aStream [
	aStream nextPutAll: (FOHTMLRenderVisitor render: self document)
]
