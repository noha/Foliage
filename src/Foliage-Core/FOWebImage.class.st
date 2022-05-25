Class {
	#name : #FOWebImage,
	#superclass : #FOFileBasedWebEntity,
	#category : #'Foliage-Core-Model'
}

{ #category : #testing }
FOWebImage class >> supportedFileExtensions [ 
	^ #( gif jpg jpeg png ico  ) 
]

{ #category : #visiting }
FOWebImage >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitWebImage: self  
]
