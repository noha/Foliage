Class {
	#name : #FOWebImage,
	#superclass : #FOFileBasedWebEntity,
	#category : #'Foliage-Core-Model'
}

{ #category : #testing }
FOWebImage class >> supportedFileExtensions [ 
	^ #( gif jpg jpeg png ) 
]

{ #category : #visiting }
FOWebImage >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitWebImage: self  
]
