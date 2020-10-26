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
	^ FOHTMLPage new
		raw: file
]

{ #category : #'instance creation' }
FOHTMLReader >> readFrom: aZnCharacterReadStream [ 
	^ FOHTMLPage new
]
