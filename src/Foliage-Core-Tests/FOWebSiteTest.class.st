Class {
	#name : #FOWebSiteTest,
	#superclass : #TestCase,
	#category : #'Foliage-Core-Tests'
}

{ #category : #tests }
FOWebSiteTest >> testDefaultPaths [
	| site |
	site := FOWebSite new.
	self assert: site contentPath asString equals: 'content' asFileReference asString.
	self assert: site targetPath asString equals: 'docs' asFileReference asString.
	self assert: site templatePath asString equals: 'templates' asFileReference asString.
	self assert: site dataPath asString equals: 'data' asFileReference asString
]

{ #category : #tests }
FOWebSiteTest >> testExplicitPathsOverrideDefaults [
	| site |
	site := FOWebSite new
		contentPath: '/tmp/content';
		targetPath: '/tmp/docs' asFileReference;
		yourself.
	self assert: site contentPath asString equals: '/tmp/content' asFileReference asString.
	self assert: site targetPath asString equals: '/tmp/docs' asFileReference asString
]

{ #category : #tests }
FOWebSiteTest >> testTemplatePathForLayout [
	| site |
	site := FOWebSite new templatePath: '/tmp/templates' asFileReference; yourself.
	self assert: (site templatePathForLayout: 'blog-post') asString equals: '/tmp/templates/blog-post' asFileReference asString.
	self assert: (site templatePathForLayout: 'blog-post' partial: 'page-header') asString equals: '/tmp/templates/page-header' asFileReference asString
]

{ #category : #tests }
FOWebSiteTest >> testBlogPathsDefaultsToEmpty [
	self assert: FOWebSite new blogPaths isEmpty
]

{ #category : #tests }
FOWebSiteTest >> testBlogPathsCanBeOverriddenBySubclass [
	self assert: FOTestBlogWebsite new blogPaths equals: #( 'blog' )
]

{ #category : #tests }
FOWebSiteTest >> testRootIsBuiltOnInitializeAndLinkedBack [
	| site |
	site := FOWebSite new.
	self assert: site root isRoot.
	self assert: site root website equals: site
]

{ #category : #tests }
FOWebSiteTest >> testImportBuildsRealTreeFromDisk [
	| tempDir site logo |
	tempDir := FileLocator temp / ('fo-website-test-', UUID new asString36).
	tempDir ensureCreateDirectory.
	[
		(tempDir / 'images') ensureCreateDirectory.
		((tempDir / 'images') / 'logo.png') writeStreamDo: [ :s | s nextPutAll: 'fake png' ].
		site := FOWebSite new
			contentPath: tempDir;
			targetPath: (tempDir / 'docs');
			yourself.
		site import.
		logo := (site resolvePath: (RelativePath from: 'images')) / 'logo.png'.
		self assert: (logo isKindOf: FOWebImage)
	] ensure: [ tempDir deleteAll ]
]
