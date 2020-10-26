Class {
	#name : #FOImageReader,
	#superclass : #FORawReader,
	#category : #'Foliage-Core'
}

{ #category : #testing }
FOImageReader class >> supportedFileExtensions [ 
	^ #( gif jpg jpeg png ) 
]

{ #category : #accessing }
FOImageReader >> model [ 
	^ FOWebImage new 
		raw: file
]
