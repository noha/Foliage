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

{ #category : #accessing }
FOWebSite >> absoluteLinkFor: aFOWebResourece [
	^ baseUri asZnUrl / (aFOWebResourece pathString)  
]

{ #category : #visiting }
FOWebSite >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitWebsite: self 
]

{ #category : #adding }
FOWebSite >> addBlogAt: aFolder [
	"shortcut for the default case having blog posts in one folder"
	| blog |
	blog := FOBlog posts: aFolder allPages.
	self blog: blog.
	self 
		atPath: (aFolder path / 'index.html') 
		add: blog overviewPage  
]

{ #category : #adding }
FOWebSite >> atPath: path add: aWebEntity [ 
	^ root atPath: path asPath add: aWebEntity 
]

{ #category : #accessing }
FOWebSite >> baseUri [
	^ baseUri
]

{ #category : #accessing }
FOWebSite >> baseUri: anObject [
	baseUri := anObject
]

{ #category : #'as yet unclassified' }
FOWebSite >> blog [
	^ self propertyAt: #blog
]

{ #category : #accessing }
FOWebSite >> blog: aFOBlog [ 
	self 
		propertyAt: #blog 
		put: aFOBlog 
]

{ #category : #building }
FOWebSite >> build [ 
	| blogOverview |
	self importDirectory: self rawPath.
	blogOverview := FOBlogOverviewBuilder new 
		folder: self root / #blog;
		overviewPage.
	self 
		atPath: '/index.html' 
		add: blogOverview.  
	self  
		atPath: '/blog/index.html' 
		add: blogOverview duplicate.
	self publish.

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
	FOSiteModelBuilder new 
		website: self;
		path: path;
		build.
]

{ #category : #initialization }
FOWebSite >> initialize [ 
	super initialize.
	properties := Dictionary new.
	root := self buildRoot 
]

{ #category : #'instance creation' }
FOWebSite >> newRenderContext [
	^ FORenderContext new 
		website: self
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
	^ self templatePath / partialName
]
