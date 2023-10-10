Class {
	#name : #FOPageWithMetadata,
	#superclass : #FOHTMLPage,
	#instVars : [
		'meta'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #testing }
FOPageWithMetadata class >> isAbstract [ 
	^ self == FOPageWithMetadata  
]

{ #category : #accessing }
FOPageWithMetadata >> defaultLayout [

	^ self parent defaultLayout
]

{ #category : #converting }
FOPageWithMetadata >> emitSlots [

	^ super emitSlots, #(meta)
]

{ #category : #testing }
FOPageWithMetadata >> hasDocumentType [
	^ meta includesKey: 'layout'
]

{ #category : #testing }
FOPageWithMetadata >> isPage [
	^ true
]

{ #category : #testing }
FOPageWithMetadata >> isPublished [
	^ self publishDate notNil
]

{ #category : #accessing }
FOPageWithMetadata >> layout [
	^ self meta 
		at: 'layout'
		ifAbsent: [ self defaultLayout ]
]

{ #category : #accessing }
FOPageWithMetadata >> layout: aString [
	^ self meta 
		at: 'layout'
		put: aString
]

{ #category : #accessing }
FOPageWithMetadata >> meta [
	^ meta ifNil: [ 
		meta := Dictionary new ]
]

{ #category : #accessing }
FOPageWithMetadata >> meta: aCollection [ 
	meta := aCollection 
]

{ #category : #accessing }
FOPageWithMetadata >> metaAt: key put: value [
	
	self meta 
		at: key
		put: value
]

{ #category : #accessing }
FOPageWithMetadata >> publishDate [
	^ self meta 
		at: #publishDate 
		ifPresent: [ :string |
			"reading from file an empty date easily ends up being an 
			empty string so we consider it absent in this case" 
			string 
				ifNotEmpty: [ (DateAndTime fromString: string) asDate ]
				ifEmpty: [ nil ]  ]
		ifAbsent: [ nil ]
]

{ #category : #accessing }
FOPageWithMetadata >> title [
	^ self meta at: 'title' ifAbsent: ''
]

{ #category : #accessing }
FOPageWithMetadata >> title: aString [ 
	self meta 
		at: 'title'
		put: aString
]
