Class {
	#name : #FOWebImage,
	#superclass : #FOWebBinaryObject,
	#category : #'Foliage-Core'
}

{ #category : #testing }
FOWebImage class >> supportedFileExtensions [ 
	^ #( gif jpg jpeg png ) 
]

{ #category : #visiting }
FOWebImage >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitWebImage: self  
]