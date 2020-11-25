Class {
	#name : #FOSiteModelBuilder,
	#superclass : #Object,
	#instVars : [
		'website',
		'path'
	],
	#category : #'Foliage-Core'
}

{ #category : #accessing }
FOSiteModelBuilder class >> path: aString [
	^ self new
		path: aString asFileReference 
]

{ #category : #generation }
FOSiteModelBuilder >> build [
	| files sources model |
	sources := OrderedCollection new.
	files := path allFiles.
	files do: [ :file | 
		[ (self readerForExtension: file extension) ifNotNil: [ :reader | 
			model := (reader file: file) model.
			website 
				atPath: (website relativeRawPath: file)
				add: model ] ]
				on: NeoJSONParseError 
				do: [ :error | Transcript show: 'could not read in ', file asString; cr ] ].
	^ sources
]

{ #category : #accessing }
FOSiteModelBuilder >> extensionsToIgnore [
	^ #( swp DS_Store)
]

{ #category : #accessing }
FOSiteModelBuilder >> path: aFileReference [ 
	path := aFileReference 
]

{ #category : #accessing }
FOSiteModelBuilder >> readerForExtension: aString [ 
	(self extensionsToIgnore includes: aString) ifTrue: [ 
		^ nil ].
	(FORawReader forFileExtension: aString)
		ifNotNil: [ :cls | ^ cls ].
	Error signal. 
]

{ #category : #accessing }
FOSiteModelBuilder >> website: aWebsite [ 
	website := aWebsite 
]
