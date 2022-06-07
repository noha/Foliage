Class {
	#name : #FOFileObject,
	#superclass : #FOFileBasedWebEntity,
	#category : #'Foliage-Core-Model'
}

{ #category : #testing }
FOFileObject class >> supportedFileExtensions [ 
	^ #( css js )
]

{ #category : #visiting }
FOFileObject >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitFileObject: self 
]
