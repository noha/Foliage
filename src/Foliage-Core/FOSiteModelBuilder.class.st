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
	| files sources |
	sources := OrderedCollection new.
	files := path allFiles.
	files do: [ :file | 
		(self modelForExtension: file extension) ifNotNil: [ :model | 
			model 
				path: (website relativeRawPath: file).
			website addResource: model ]
		].
	^ sources
]

{ #category : #accessing }
FOSiteModelBuilder >> extensionsToIgnore [
	^ #( swp DS_Store)
]

{ #category : #accessing }
FOSiteModelBuilder >> modelForExtension: aString [ 
	(self extensionsToIgnore includes: aString) ifTrue: [ 
		^ nil ].
	(FOWebResource forFileExtension: aString)
		ifNotNil: [ :cls | ^ cls new ].
	Error signal. 
]

{ #category : #accessing }
FOSiteModelBuilder >> path: aFileReference [ 
	path := aFileReference 
]

{ #category : #accessing }
FOSiteModelBuilder >> website: aWebsite [ 
	website := aWebsite 
]
