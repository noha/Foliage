Class {
	#name : #FOImageReader,
	#superclass : #FORawReader,
	#category : #'Foliage-Core-Reader'
}

{ #category : #testing }
FOImageReader class >> supportedFileExtensions [ 
	^ #( gif jpg jpeg png ) 
]

{ #category : #accessing }
FOImageReader >> model [ 
	^ FOWebImage new 
		sourcePath: file asPath
]
