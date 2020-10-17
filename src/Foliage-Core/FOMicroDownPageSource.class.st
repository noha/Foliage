Class {
	#name : #FOMicroDownPageSource,
	#superclass : #FOPageSource,
	#category : #'Foliage-Core'
}

{ #category : #testing }
FOMicroDownPageSource class >> supportedFileExtensions [
	^ #( md )
]

{ #category : #visiting }
FOMicroDownPageSource >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitMicrodownPageSource: self 
]
