Class {
	#name : #FOImporter,
	#superclass : #Object,
	#instVars : [
		'website'
	],
	#category : #'Foliage-Core-Base'
}

{ #category : #accessing }
FOImporter >> extensionsToIgnore [
	^ #( swp DS_Store )
]

{ #category : #generation }
FOImporter >> readAll: files [
	"Any read/parse failure aborts the whole import - no catch-and-skip.
	A broken file should be fixed before publishing, not silently dropped."
	files do: [ :file | self readFile: file ]
]

{ #category : #generation }
FOImporter >> readFile: file [
	self
		readFile: file
		path: (website relativeContentPath: file)
]

{ #category : #generation }
FOImporter >> readFile: file path: aPath [
	| model |
	(self readerForExtension: file extension) ifNotNil: [ :reader |
		model := (reader file: file) model.
		(website resolvePath: aPath parent)
			at: aPath basename
			put: model ]
]

{ #category : #accessing }
FOImporter >> readerForExtension: aString [
	(self extensionsToIgnore includes: aString) ifTrue: [ ^ nil ].
	(FORawReader forFileExtension: aString) ifNotNil: [ :cls | ^ cls ].
	^ FOFileReader
]

{ #category : #accessing }
FOImporter >> website: aWebsite [
	website := aWebsite
]
