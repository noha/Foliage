Class {
	#name : #FOPageReader,
	#superclass : #Object,
	#instVars : [
		'page'
	],
	#category : #'Foliage-Core'
}

{ #category : #reading }
FOPageReader class >> on: aReadStream [ 
	^ self new
		readFrom: aReadStream 
]

{ #category : #accessing }
FOPageReader >> page [
	^ page
]

{ #category : #reading }
FOPageReader >> readFrom: aReadStream [ 
	page := FOPageSource new.
	page 
		meta: (NeoJSONReader on: aReadStream) next;
		content: (MicroDownParser parse: aReadStream upToEnd). 
]
