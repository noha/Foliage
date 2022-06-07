Class {
	#name : #FOFileReader,
	#superclass : #FORawReader,
	#category : #'Foliage-Core-Reader'
}

{ #category : #testing }
FOFileReader class >> supportedFileExtensions [ 
	^ #( css js ico )
]

{ #category : #accessing }
FOFileReader >> model [ 
	^ FOFileObject new 
		sourcePath: file asPath
]
