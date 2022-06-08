Class {
	#name : #FOWebSite,
	#superclass : #Object,
	#instVars : [
		'baseUri',
		'targetPath',
		'templatePath',
		'rawPath',
		'model',
		'root',
		'properties'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'Foliage-Core-RSS'
}

{ #category : #'instance creation' }
FOWebSite class >> build [
	^ self instance build
]

{ #category : #'instance creation' }
FOWebSite class >> instance [
	^ instance ifNil: [ 
		instance := self new ]
]

{ #category : #resetting }
FOWebSite class >> reset [
	instance := nil
]

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
