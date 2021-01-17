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
	^ self meta at: 'layout'
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

{ #category : #'instance creation' }
FOPageWithMetadata >> newRenderContext [
	^ self website newRenderContext 
		page: self
]

{ #category : #accessing }
FOPageWithMetadata >> publishDate [
	^ self meta 
		at: #publishDate 
		ifPresent: [ :string | (DateAndTime fromString: string) asDate   ]
		ifAbsent: [ nil ]
]

{ #category : #accessing }
FOPageWithMetadata >> title [
	^ self meta at: 'title'
]
