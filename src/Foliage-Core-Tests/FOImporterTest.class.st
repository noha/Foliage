Class {
	#name : #FOImporterTest,
	#superclass : #TestCase,
	#instVars : [
		'tempDir',
		'website',
		'importer'
	],
	#category : #'Foliage-Core-Tests'
}

{ #category : #running }
FOImporterTest >> setUp [
	super setUp.
	tempDir := FileLocator temp / ('fo-importer-test-', UUID new asString36).
	tempDir ensureCreateDirectory.
	website := FOTestWebsite new
		contentPath: tempDir;
		outputPath: (tempDir / 'docs');
		yourself.
	website root: (FOWebsiteRoot new parent: website; yourself).
	importer := FOImporter new website: website; yourself
]

{ #category : #running }
FOImporterTest >> tearDown [
	tempDir ifNotNil: [ tempDir exists ifTrue: [ tempDir deleteAll ] ].
	super tearDown
]

{ #category : #private }
FOImporterTest >> writeFile: aRelativeName contents: aString [
	| file |
	file := tempDir / aRelativeName.
	file parent ensureCreateDirectory.
	file writeStreamDo: [ :s | s nextPutAll: aString ].
	^ file
]

{ #category : #tests }
FOImporterTest >> testImportBuildsExpectedTreeShape [
	| files logo styles |
	self writeFile: 'images/logo.png' contents: 'not really a png'.
	self writeFile: 'css/styles.css' contents: 'body {}'.
	files := tempDir allFiles.
	importer readAll: files.
	logo := (website resolvePath: (RelativePath from: 'images')) / 'logo.png'.
	styles := (website resolvePath: (RelativePath from: 'css')) / 'styles.css'.
	self assert: (logo isKindOf: FOWebImage).
	self assert: (styles isKindOf: FOFileObject).
	self assert: logo sourcePath asString equals: (tempDir / 'images/logo.png') asPath asString
]

{ #category : #tests }
FOImporterTest >> testUnregisteredExtensionFallsBackToFileReader [
	| files page |
	self writeFile: 'robots.txt' contents: 'User-agent: *'.
	files := tempDir allFiles.
	importer readAll: files.
	page := website root / 'robots.txt'.
	self assert: (page isKindOf: FOFileObject)
]

{ #category : #tests }
FOImporterTest >> testHtmlFileBecomesFOHTMLPage [
	| files page |
	self writeFile: 'about.html' contents: '<html><body>Hi</body></html>'.
	files := tempDir allFiles.
	importer readAll: files.
	page := website root / 'about.html'.
	self assert: (page isKindOf: FOHTMLPage)
]

{ #category : #tests }
FOImporterTest >> testIgnoredExtensionIsSkipped [
	| files |
	self writeFile: '.DS_Store' contents: 'junk'.
	files := tempDir allFiles.
	importer readAll: files.
	self assert: website root items isEmpty
]

{ #category : #tests }
FOImporterTest >> testBrokenFileAbortsWholeImport [
	| files |
	self writeFile: 'good.css' contents: 'body {}'.
	self writeFile: 'bad.broken' contents: 'anything'.
	files := tempDir allFiles.
	self should: [ importer readAll: files ] raise: Error
]
