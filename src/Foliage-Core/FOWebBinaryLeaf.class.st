Class {
	#name : #FOWebBinaryLeaf,
	#superclass : #FOWebLeaf,
	#category : #'Foliage-Core'
}

{ #category : #testing }
FOWebBinaryLeaf class >> isAbstract [ 
	^ self == FOWebBinaryLeaf  
]

{ #category : #printing }
FOWebBinaryLeaf >> printOn: aStream [
	"Append to the argument, aStream, a sequence of characters that  
	identifies the receiver."

	| title |
	title := self class name.
	aStream
		nextPutAll: (title first isVowel ifTrue: ['an '] ifFalse: ['a ']);
		nextPutAll: title
]
