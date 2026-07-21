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
		'blogPaths'
	],
	#category : #'Foliage-Core-Base'
}

{ #category : #arithmetic }
FOWebSite >> / anObject [
	^ root / anObject
]

{ #category : #accessing }
FOWebSite >> absoluteLinkFor: aFOWebResource [
	^ baseUri asZnUrl / aFOWebResource pathString
]

{ #category : #visiting }
FOWebSite >> acceptFOVisitor: aFOVisitor [
	^ aFOVisitor visitWebsite: self
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
FOWebSite >> blogPaths [
	"Top-level (direct child of root) folder names that should become FOBlog
	instead of a plain FOWebFolder as soon as the import creates them.
	Same ivar-with-overridable-default pattern as rawPath/targetPath/
	templatePath: a subclass can override defaultBlogPaths (like
	NohaWebsite overrides defaultRawPath) for a compile-time declaration, or
	a caller can set blogPaths: at runtime (e.g. FOPublisher, driven by a
	per-invocation .foliage.ston project file) - either way works. Replaces
	the old post-hoc FOWebFolder>>convertToBlog object surgery."
	^ blogPaths ifNil: [ blogPaths := self defaultBlogPaths ]
]

{ #category : #accessing }
FOWebSite >> blogPaths: aCollection [
	blogPaths := aCollection
]

{ #category : #accessing }
FOWebSite >> defaultBlogPaths [
	^ #()
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
	self importer readAll: path allFiles
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
	^ rawPath ifNil: [ rawPath := self defaultRawPath asFileReference ]
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
	^ targetPath ifNil: [ targetPath := self defaultTargetPath asFileReference ]
]

{ #category : #accessing }
FOWebSite >> targetPath: anObject [
	targetPath := anObject
]

{ #category : #accessing }
FOWebSite >> templatePath [
	^ templatePath ifNil: [ templatePath := self defaultTemplatePath asFileReference ]
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
FOWebSite >> templatePathForLayout: aString partial: partialName [
	^ self templatePath / partialName
]
