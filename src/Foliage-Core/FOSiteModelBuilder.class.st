Class {
	#name : #FOSiteModelBuilder,
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
FOSiteModelBuilder class >> path: aString [
	^ self new
		path: aString asFileReference 
]

{ #category : #generation }
FOSiteModelBuilder >> build [
	| files site |
	site := Dictionary new.
	files := website allRawFiles.
	files do: [ :file | 
		(self modelForExtension: file extension) ifNotNil: [ :model | | path |
			path := website relativeRawPath: file.
			model 
				path: path.
			site at: path put: model ]
		].
	^ site
]

{ #category : #accessing }
FOSiteModelBuilder >> modelForExtension: aString [ 
	(aString = #md) ifTrue: [ 
		^ FOPageSource new  ].
	Error signal.
]

{ #category : #accessing }
FOSiteModelBuilder >> website: aWebsite [ 
	website := aWebsite 
]
