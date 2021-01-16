Class {
	#name : #FOHTMLReader,
	#superclass : #FORawReader,
	#category : #'Foliage-Core'
}

{ #category : #testing }
FOHTMLReader class >> supportedFileExtensions [
	^ #( html )
]

{ #category : #'instance creation' }
FOHTMLReader >> model [
	^ FOHTMLEntity new
		sourcePath: file asPath
]
