Class {
	#name : #FOCSSObject,
	#superclass : #FOFileBasedWebEntity,
	#category : #'Foliage-Core-Model'
}

{ #category : #testing }
FOCSSObject class >> supportedFileExtensions [ 
	^ #( css )
]

{ #category : #visiting }
FOCSSObject >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitCSSObject: self 
]
