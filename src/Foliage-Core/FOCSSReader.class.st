Class {
	#name : #FOCSSReader,
	#superclass : #FORawReader,
	#category : #'Foliage-Core-Reader'
}

{ #category : #testing }
FOCSSReader class >> supportedFileExtensions [ 
	^ #( css ) 
]

{ #category : #accessing }
FOCSSReader >> model [ 
	^ FOCSSObject new 
		sourcePath: file asPath
]
