Class {
	#name : #FOImporter,
	#superclass : #Object,
	#instVars : [
		'website'
	],
	#category : #'Foliage-Core-Base'
}

{ #category : #accessing }
FOImporter class >> path: aString [
	^ self new
		path: aString asFileReference 
]

{ #category : #accessing }
FOImporter >> extensionsToIgnore [
	^ #( swp DS_Store)
]

{ #category : #generation }
FOImporter >> readAll: files [
	files do: [ :file | 
		self readFile: file ]
]

{ #category : #generation }
FOImporter >> readFile: file [
	self 
		readFile: file
		path: (website relativeRawPath: file)
]

{ #category : #generation }
FOImporter >> readFile: file path: aPath [ 
	|  model |
	[ (self readerForExtension: file extension) ifNotNil: [ :reader | 
		model := (reader file: file) model.
		(website resolvePath: aPath parent)
			at: aPath basename
			put: model ] ]
			on: NeoJSONParseError 
			do: [ :error | Transcript show: 'could not read in ', file asString; cr ]
]

{ #category : #accessing }
FOImporter >> readerForExtension: aString [ 
	(self extensionsToIgnore includes: aString) ifTrue: [ 
		^ nil ].
	(FORawReader forFileExtension: aString)
		ifNotNil: [ :cls | ^ cls ].
	Error signal. 
]

{ #category : #accessing }
FOImporter >> website: aWebsite [ 
	website := aWebsite 
]
