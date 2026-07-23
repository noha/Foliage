Class {
	#name : #FOPublishVisitorTest,
	#superclass : #TestCase,
	#instVars : [
		'tempDir',
		'site'
	],
	#category : #'Foliage-Core-Tests'
}

{ #category : #running }
FOPublishVisitorTest >> setUp [
	super setUp.
	tempDir := FileLocator temp / ('fo-publish-visitor-test-', UUID new asString36).
	tempDir ensureCreateDirectory.
	(tempDir / 'templates') ensureCreateDirectory.
	(tempDir / 'templates' / 'page') writeStreamDo: [ :s |
		s nextPutAll: '<html><title>{{page.title}}</title>{{{ body }}}</html>' ].
	site := FOWebSite new
		outputPath: (tempDir / 'docs');
		templatePath: (tempDir / 'templates');
		yourself
]

{ #category : #running }
FOPublishVisitorTest >> tearDown [
	tempDir ifNotNil: [ tempDir exists ifTrue: [ tempDir deleteAll ] ].
	super tearDown
]

{ #category : #tests }
FOPublishVisitorTest >> testWebFolderIsCreatedExactlyOnce [
	| folder |
	folder := FOCountingTestFolder new.
	site root at: #images put: folder.
	FOPublishVisitor new start: site.
	self assert: folder createOnTargetCallCount equals: 1.
	self assert: (tempDir / 'docs' / 'images') exists
]

{ #category : #tests }
FOPublishVisitorTest >> testFoliagePageIsPublishedWithRenderedContent [
	| page publishedFile |
	page := FOFoliagePage new
		meta: (Dictionary new at: #title put: 'Hi'; at: #layout put: 'page'; yourself);
		document: (FOMarkdownParser parse: 'Body text.');
		yourself.
	site root at: #'my-post' put: page.
	FOPublishVisitor new start: site.
	publishedFile := tempDir / 'docs' / 'my-post.html'.
	self assert: publishedFile exists.
	self assert: publishedFile contents equals: '<html><title>Hi</title><p>Body text.</p></html>'
]

{ #category : #tests }
FOPublishVisitorTest >> testWebImageIsCopiedToTarget [
	| image sourceFile |
	sourceFile := tempDir / 'source-logo.png'.
	sourceFile writeStreamDo: [ :s | s nextPutAll: 'fake image bytes' ].
	image := FOWebImage new sourcePath: sourceFile asPath; yourself.
	site root at: #'logo.png' put: image.
	FOPublishVisitor new start: site.
	self assert: (tempDir / 'docs' / 'logo.png') exists.
	self assert: (tempDir / 'docs' / 'logo.png') contents equals: 'fake image bytes'
]

{ #category : #tests }
FOPublishVisitorTest >> testNestedFolderStructureIsPreserved [
	| blogFolder page |
	blogFolder := FOWebFolder new.
	site root at: #blog put: blogFolder.
	page := FOFoliagePage new
		meta: (Dictionary new at: #title put: 'Post'; at: #layout put: 'page'; yourself);
		document: (FOMarkdownParser parse: 'Text.');
		yourself.
	blogFolder at: #'post-one' put: page.
	FOPublishVisitor new start: site.
	self assert: (tempDir / 'docs' / 'blog') exists.
	self assert: (tempDir / 'docs' / 'blog' / 'post-one.html') exists
]
