Class {
	#name : #FOPageWithMetadata,
	#superclass : #FOHTMLPage,
	#instVars : [
		'meta'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #accessing }
FOPageWithMetadata >> defaultLayout [
	^ self parent defaultLayout
]

{ #category : #testing }
FOPageWithMetadata >> hasDocumentType [
	^ self meta includesKey: #layout
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
		at: #layout
		ifAbsent: [ self defaultLayout ]
]

{ #category : #accessing }
FOPageWithMetadata >> layout: aString [
	^ self meta at: #layout put: aString
]

{ #category : #accessing }
FOPageWithMetadata >> meta [
	^ meta ifNil: [ meta := Dictionary new ]
]

{ #category : #accessing }
FOPageWithMetadata >> meta: aDictionary [
	meta := aDictionary
]

{ #category : #accessing }
FOPageWithMetadata >> metaAt: key put: value [
	self meta at: key put: value
]

{ #category : #accessing }
FOPageWithMetadata >> publishDate [
	^ self meta
		at: #publishDate
		ifPresent: [ :string |
			"an empty value ('publishDate:' with nothing after it) is treated as
			absent, not as an error"
			string
				ifNotEmpty: [ (DateAndTime fromString: string) asDate ]
				ifEmpty: [ nil ] ]
		ifAbsent: [ nil ]
]

{ #category : #accessing }
FOPageWithMetadata >> title [
	^ self meta at: #title
]

{ #category : #accessing }
FOPageWithMetadata >> title: aString [
	self meta at: #title put: aString
]
