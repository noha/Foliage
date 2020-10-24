Class {
	#name : #FOPageSource,
	#superclass : #FOTextEntity,
	#instVars : [
		'meta',
		'content'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #testing }
FOPageSource class >> isAbstract [ 
	^ self == FOPageSource  
]

{ #category : #accessing }
FOPageSource >> content [
	^ content
]

{ #category : #accessing }
FOPageSource >> content: anObject [ 
	content := anObject 
]

{ #category : #testing }
FOPageSource >> hasDocumentType [
	^ meta includesKey: 'layout'
]

{ #category : #testing }
FOPageSource >> isPage [
	^ true
]

{ #category : #testing }
FOPageSource >> isPublished [
	^ self publishDate notNil
]

{ #category : #accessing }
FOPageSource >> layout [
	^ self meta at: 'layout'
]

{ #category : #accessing }
FOPageSource >> meta [
	^ meta ifNil: [ 
		meta := Dictionary new ]
]

{ #category : #accessing }
FOPageSource >> meta: aCollection [ 
	meta := aCollection 
]

{ #category : #accessing }
FOPageSource >> metaAt: key put: value [
	self meta 
		at: key
		put: value
]

{ #category : #accessing }
FOPageSource >> publishDate [
	^ self meta 
		at: #publishDate 
		ifPresent: [ :string | (DateAndTime fromString: string) asDate   ]
		ifAbsent: [ nil ]
]

{ #category : #'as yet unclassified' }
FOPageSource >> publishPath [
	self flag: #todo.
	"path is not properly defined. When there is raw path and when publich path?"
	^ (path parent / path base), #html  

]

{ #category : #accessing }
FOPageSource >> validate [ 
	self hasDocumentType ifFalse: [ 
		Error signal: 'document in ', path asString, ' is missing type' ].
]
