"
I represent the web site to generate.
I hold configuration needed for the generation (pathes, properties, user data) as well as the Root element of the web site that contains all other web site elements.

I'm the entry point of visitors.

You can use the `publish` method to run the publication of the web site.
"
Class {
	#name : #FOWebSite,
	#superclass : #Object,
	#instVars : [
		'baseUri',
		'targetPath',
		'templatePath',
		'rawPath',
		'root',
		'properties',
		'data'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #arithmetic }
FOWebSite >> / anObject [
	^ root / anObject
]

{ #category : #accessing }
FOWebSite >> absoluteLinkFor: aFOWebResourece [
	^ baseUri asZnUrl / (aFOWebResourece pathString)  
]

{ #category : #visiting }
FOWebSite >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitWebsite: self 
]

{ #category : #logging }
FOWebSite >> asBeaconSignal [

	^ FOObjectSignal new 
		object: self;
		slots: #(baseUri targetPath templatePath rawPath);
		yourself
]

{ #category : #accessing }
FOWebSite >> baseUri [
	^ baseUri
]

{ #category : #accessing }
FOWebSite >> baseUri: anObject [
	baseUri := anObject
]

{ #category : #accessing }
FOWebSite >> buildRoot [
	^ FOWebsiteRoot new
		parent: self 
]

{ #category : #accessing }
FOWebSite >> data [

	^ data
]

{ #category : #accessing }
FOWebSite >> dataPath: aString [

	aString ifNil: [ ^ self ].
	
	data := STON fromString: aString asFileReference contents
]

{ #category : #accessing }
FOWebSite >> defaultRawPath [
	^ 'raw'
]

{ #category : #accessing }
FOWebSite >> defaultTargetPath [
	^ 'docs'
]

{ #category : #accessing }
FOWebSite >> defaultTemplatePath [ 
	^ 'templates'
]

{ #category : #building }
FOWebSite >> import [
	self importDirectory: self rawPath 
]

{ #category : #building }
FOWebSite >> importDirectory: path [ 
	self importer
		readAll: path allFiles
]

{ #category : #accessing }
FOWebSite >> importer [ 
	^ FOImporter new 
		website: self;
		yourself
]

{ #category : #initialization }
FOWebSite >> initialize [ 
	super initialize.
	properties := Dictionary new.
	data := Dictionary new: 0.
	root := self buildRoot
]

{ #category : #logging }
FOWebSite >> log [

	self log: self withSlots: #(baseUri targetPath templatePath rawPath)
]

{ #category : #accessing }
FOWebSite >> properties [
	^ properties
]

{ #category : #accessing }
FOWebSite >> propertyAt: aString [ 
	^ properties at: aString
]

{ #category : #accessing }
FOWebSite >> propertyAt: aString put: anObject [
	^ properties 
		at: aString
		put: anObject 
]

{ #category : #building }
FOWebSite >> publish [
	FOPublishVisitor new
		start: self

]

{ #category : #accessing }
FOWebSite >> rawPath [
	^ rawPath ifNil: [ 
		rawPath := self defaultRawPath asFileReference ]
]

{ #category : #accessing }
FOWebSite >> rawPath: anObject [
	rawPath := anObject asFileReference 
]

{ #category : #accessing }
FOWebSite >> relativeRawPath: aFileReference [
	^ aFileReference asAbsolute relativeTo: self rawPath asAbsolute 
]

{ #category : #navigating }
FOWebSite >> resolvePath: aPath [ 
	^ root resolvePath: aPath
]

{ #category : #accessing }
FOWebSite >> root [
	^ root
]

{ #category : #accessing }
FOWebSite >> targetPath [
	^ targetPath ifNil: [ 
		targetPath := self defaultTargetPath asFileReference ]
]

{ #category : #accessing }
FOWebSite >> targetPath: anObject [
	targetPath := anObject
]

{ #category : #accessing }
FOWebSite >> targetPathFor: aWebObject [
	^ self targetPath resolvePath: aWebObject path
]

{ #category : #accessing }
FOWebSite >> templatePath [
	^ templatePath ifNil: [ 
		templatePath := self defaultTemplatePath asFileReference ]
]

{ #category : #accessing }
FOWebSite >> templatePath: anObject [
	templatePath := anObject
]

{ #category : #accessing }
FOWebSite >> templatePathForLayout: aString [ 
	^ self templatePath / aString
]

{ #category : #accessing }
FOWebSite >> templatePathForLayout: aString  partial: partialName [
	^ self templatePath / partialName
]
