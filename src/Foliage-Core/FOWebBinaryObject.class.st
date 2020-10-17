Class {
	#name : #FOWebBinaryObject,
	#superclass : #FOWebObject,
	#category : #'Foliage-Core'
}

{ #category : #testing }
FOWebBinaryObject class >> isAbstract [ 
	^ self == FOWebBinaryObject  
]

{ #category : #printing }
FOWebBinaryObject >> printOn: aStream [
	"Append to the argument, aStream, a sequence of characters that  
	identifies the receiver."

	| title |
	title := self class name.
	aStream
		nextPutAll: (title first isVowel ifTrue: ['an '] ifFalse: ['a ']);
		nextPutAll: title
]
