Class {
	#name : #FOFileReader,
	#superclass : #FORawReader,
	#category : #'Foliage-Core-Reader'
}

{ #category : #testing }
FOFileReader class >> supportedFileExtensions [
	^ #( css js )
]

{ #category : #accessing }
FOFileReader >> model [
	^ FOFileObject new
		sourcePath: file asPath
]
