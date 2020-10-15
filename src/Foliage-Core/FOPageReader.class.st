Class {
	#name : #FOPageReader,
	#superclass : #Object,
	#category : #'Foliage-Core'
}

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
