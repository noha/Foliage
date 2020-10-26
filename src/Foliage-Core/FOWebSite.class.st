Class {
	#name : #FOWebSite,
	#superclass : #Object,
	#instVars : [
		'targetPath',
		'templatePath',
		'rawPath',
		'model',
		'root'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'Foliage-Core-Model'
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

{ #category : #visiting }
FOWebSite >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitWebsite: self 
]

{ #category : #adding }
FOWebSite >> addResource: aResource [
	root addResource: aResource 
]

{ #category : #adding }
FOWebSite >> atPath: aRelativePath add: aWebEntity [ 
	root atPath: aRelativePath asPath add: aWebEntity 
]

{ #category : #building }
FOWebSite >> build [ 
	| blogOverview |
	self importDirectory: self rawPath.
	blogOverview := FOBlogOverviewBuilder new 
		folder: self root / #blog;
		overviewPage.
	self addResource: (blogOverview 
		path: (RelativePath from: 'index.md')).
	self publish.

]

{ #category : #accessing }
FOWebSite >> buildRoot [
	^ FOWebsiteRoot new
		parent: self 
]

{ #category : #accessing }
FOWebSite >> defaultRawPath [
	self subclassResponsibility 
]

{ #category : #accessing }
FOWebSite >> defaultTargetPath [
	self subclassResponsibility 
]

{ #category : #accessing }
FOWebSite >> defaultTemplatePath [ 
	self subclassResponsibility 
]

{ #category : #building }
FOWebSite >> importDirectory: path [ 
	FOSiteModelBuilder new 
		website: self;
		path: path;
		build.
]

{ #category : #initialization }
FOWebSite >> initialize [ 
	super initialize.
	root := self buildRoot 
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
	rawPath := anObject
]

{ #category : #accessing }
FOWebSite >> rawPathFor: aWebObject [
	^ self rawPath resolve: aWebObject relativePath
]

{ #category : #'as yet unclassified' }
FOWebSite >> relativeRawPath: aFileReference [
	^ aFileReference asAbsolute relativeTo: rawPath asAbsolute
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
	^ self targetPath resolve: aWebObject path
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
	^ self templatePath / (aString, '_' , partialName)
]
