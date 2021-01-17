Class {
	#name : #FOCSSObject,
	#superclass : #FOTextEntity,
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
