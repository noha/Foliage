Class {
	#name : #FOHTMLPage,
	#superclass : #AnObsoleteFOFilePageSource,
	#category : #'Foliage-Core-Model'
}

{ #category : #accessing }
FOHTMLPage class >> supportedFileExtensions [
	^ #( html )
]

{ #category : #visiting }
FOHTMLPage >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitHTMLPageSource: self 
]
