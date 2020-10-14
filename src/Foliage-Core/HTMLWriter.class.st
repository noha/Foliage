Class {
	#name : #HTMLWriter,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #'Foliage-Core'
}

{ #category : #accessing }
HTMLWriter >> contents [ 
	^ "(stream 
		flush;
		wrappedStream) contents "
		stream contents
]

{ #category : #initialize }
HTMLWriter >> initialize [ 
	super initialize.
	stream := String new writeStream "ZnCharacterWriteStream 
		on: ByteArray new writeStream 
		encoding: 'utf-8' "
]

{ #category : #writing }
HTMLWriter >> writeHeaderLevel: anInteger with: aBlock [ 
	^ self 
		writeTag: 'h', anInteger asString
		with: aBlock
]

{ #category : #writing }
HTMLWriter >> writeTag: aString with: aBlock [ 
	stream << '<' << aString << '>'.
	aBlock value.
	stream << '</' << aString << '>'.
	
		
]

{ #category : #writing }
HTMLWriter >> writeText: aPRText [ 
	stream << aPRText text
]
