Class {
	#name : #HTMLWriter,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #'Foliage-Core-Base'
}

{ #category : #accessing }
HTMLWriter >> contents [ 
	^ "(stream 
		flush;
		wrappedStream) contents "
		stream contents
]

{ #category : #flushing }
HTMLWriter >> flush [
	stream flush
]

{ #category : #initialize }
HTMLWriter >> initialize [ 
	super initialize.
	stream := String new writeStream "ZnCharacterWriteStream 
		on: ByteArray new writeStream 
		encoding: 'utf-8' "
]

{ #category : #accessing }
HTMLWriter >> stream: aStream [ 
	stream := aStream
]

{ #category : #writing }
HTMLWriter >> writeHeaderLevel: anInteger with: aBlock [ 
	^ self 
		writeTag: 'h', anInteger asString
		with: aBlock
]

{ #category : #writing }
HTMLWriter >> writeTag: aString attributes: aDictionary with: aBlock [ 
	stream << '<' << aString.
	aDictionary 
		ifNotNil: [ 
			aDictionary asDictionary keysAndValuesDo: [ :key :value |
				stream << ' ' << key asString << '="' << value asString << '"' ] ].
	stream << '>'.
	aBlock value.
	stream << '</' << aString << '>'.
	
		
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
