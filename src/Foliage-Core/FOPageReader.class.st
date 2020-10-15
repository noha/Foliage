Class {
	#name : #FOPageReader,
	#superclass : #Object,
	#instVars : [
		'page'
	],
	#category : #'Foliage-Core'
}

{ #category : #accessing }
FOPageReader >> page [
	^ page
]

{ #category : #reading }
FOPageReader >> readFrom: aReadStream [ 
	^ self 
		readFrom: aReadStream 
		page: FOPageSource new.
	
]

{ #category : #reading }
FOPageReader >> readFrom: aReadStream page: aPage [
	aPage 
		meta: (NeoJSONReader on: aReadStream) next;
		content: (MicroDownParser parse: aReadStream upToEnd). 
]
