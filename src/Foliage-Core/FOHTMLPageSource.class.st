Class {
	#name : #FOHTMLPageSource,
	#superclass : #FOPageSource,
	#category : #'Foliage-Core'
}

{ #category : #accessing }
FOHTMLPageSource class >> supportedFileExtensions [
	^ #( html )
]

{ #category : #visiting }
FOHTMLPageSource >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitHTMLPageSource: self 
]

{ #category : #'instance creation' }
FOHTMLPageSource >> readContentFrom: aStream [
	self halt
]
