Class {
	#name : #FOFilePageSource,
	#superclass : #FOPageSource,
	#category : #'Foliage-Core-Model'
}

{ #category : #testing }
FOFilePageSource class >> isAbstract [ 
	^ self == FOFilePageSource  
]

{ #category : #accessing }
FOFilePageSource >> content [
	^ content ifNil: [ 
		self readContents.
		content ]
]

{ #category : #accessing }
FOFilePageSource >> meta [
	^ meta ifNil: [ 
		self readContents.
		meta ]
]

{ #category : #'instance creation' }
FOFilePageSource >> readContentFrom: aStream [
	self subclassResponsibility 
]

{ #category : #accessing }
FOFilePageSource >> readContents [
	self readFrom: (self website rawPath resolve: path) readStream
]

{ #category : #'instance creation' }
FOFilePageSource >> readFrom: aStream [
	meta := self readMetaFrom: aStream.
	content := self readContentFrom: aStream.
	self validate
]

{ #category : #generation }
FOFilePageSource >> readJsonFrom: aStream [
	^ (NeoJSONReader on: aStream) next
	
]

{ #category : #generation }
FOFilePageSource >> readMetaFrom: aStream [
	^ self readJsonFrom: aStream
]
