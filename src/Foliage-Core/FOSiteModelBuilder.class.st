Class {
	#name : #FOSiteModelBuilder,
	#superclass : #Object,
	#instVars : [
		'sourcePath',
		'targetPath',
		'templatePath',
		'website',
		'root'
	],
	#category : #'Foliage-Core'
}

{ #category : #accessing }
FOSiteModelBuilder class >> path: aString [
	^ self new
		path: aString asFileReference 
]

{ #category : #generation }
FOSiteModelBuilder >> addResource: aResource [
	| container |
	container := self resolveContainer: aResource path parent.
	container add: aResource
]

{ #category : #generation }
FOSiteModelBuilder >> build [
	| files sources |
	sources := OrderedCollection new.
	files := website allRawFiles.
	files do: [ :file | 
		(self modelForExtension: file extension) ifNotNil: [ :model | 
			model 
				path: (website relativeRawPath: file).
			self addResource: model ]
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

{ #category : #resolving }
FOSiteModelBuilder >> resolveContainer: aRelativePath [ 
	^ self root resolve: aRelativePath segments
]

{ #category : #accessing }
FOSiteModelBuilder >> root [
	^ root ifNil: [ 
		root := FOWebsiteRoot new
			parent: website ]
]

{ #category : #accessing }
FOSiteModelBuilder >> website: aWebsite [ 
	website := aWebsite 
]
