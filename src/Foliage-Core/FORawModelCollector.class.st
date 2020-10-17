Class {
	#name : #FORawModelCollector,
	#superclass : #Object,
	#instVars : [
		'sourcePath',
		'targetPath',
		'templatePath',
		'website'
	],
	#category : #'Foliage-Core'
}

{ #category : #accessing }
FORawModelCollector class >> path: aString [
	^ self new
		path: aString asFileReference 
]

{ #category : #generation }
FORawModelCollector >> collect [
	| files sources |
	sources := OrderedCollection new.
	files := website allRawFiles.
	files do: [ :file | 
		(self modelForExtension: file extension) ifNotNil: [ :model | 
			model 
				path: (website relativeRawPath: file).
			sources add: model ]
		].
	^ sources
]

{ #category : #accessing }
FORawModelCollector >> modelForExtension: aString [ 
	(FOWebItem forFileExtension: aString)
		ifNotNil: [ :cls | ^ cls new ].
	Error signal.
]

{ #category : #accessing }
FORawModelCollector >> website: aWebsite [ 
	website := aWebsite 
]
