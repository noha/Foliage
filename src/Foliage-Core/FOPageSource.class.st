Class {
	#name : #FOPageSource,
	#superclass : #FOWebObject,
	#instVars : [
		'meta',
		'content'
	],
	#category : #'Foliage-Core'
}

{ #category : #testing }
FOPageSource class >> isAbstract [ 
	^ self == FOPageSource  
]

{ #category : #accessing }
FOPageSource >> content [
	^ content ifNil: [ 
		self readContents.
		content ]
]

{ #category : #accessing }
FOPageSource >> content: anObject [ 
	content := anObject 
]

{ #category : #testing }
FOPageSource >> hasDocumentType [
	^ meta includesKey: 'layout'
]

{ #category : #accessing }
FOPageSource >> layout [
	^ meta at: 'layout'
]

{ #category : #accessing }
FOPageSource >> meta: aCollection [ 
	meta := aCollection 
]

{ #category : #'instance creation' }
FOPageSource >> readContentFrom: aStream [
	self subclassResponsibility 
]

{ #category : #accessing }
FOPageSource >> readContents [
	self readFrom: (self website rawPath resolve: path) readStream
]

{ #category : #'instance creation' }
FOPageSource >> readFrom: aStream [
	meta := self readMetaFrom: aStream.
	content := self readContentFrom: aStream.
	self validate
]

{ #category : #generation }
FOPageSource >> readJsonFrom: aStream [
	^ (NeoJSONReader on: aStream) next
	
]

{ #category : #generation }
FOPageSource >> readMetaFrom: aStream [
	^ self readJsonFrom: aStream
]

{ #category : #accessing }
FOPageSource >> validate [ 
	self hasDocumentType ifFalse: [ 
		Error signal: 'document in ', path asString, ' is missing type' ].
]
