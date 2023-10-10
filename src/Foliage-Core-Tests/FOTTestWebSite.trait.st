"
Trait you can use to easily define a web site that will be defined in a memory filesystem and can be used for testing purposes.
"
Trait {
	#name : #FOTTestWebSite,
	#instVars : [
		'fs',
		'srcDir',
		'outputDir',
		'templateDir',
		'foliageConfigurationFile',
		'website',
		'dataFile'
	],
	#category : #'Foliage-Core-Tests'
}

{ #category : #running }
FOTTestWebSite >> setUpFileSystem [

	fs := FileSystem memory.
	srcDir := fs root / 'src'.
	srcDir ensureCreateDirectory.
	outputDir := fs root / 'generated'.
	foliageConfigurationFile := fs root / '.foliage.ston'.
]

{ #category : #running }
FOTTestWebSite >> setUpSources [

	(self class organization protocolNamed: #sources) methodSelectors do: [ :selector | | association |
		association := self perform: selector.
		(srcDir / association key) writeStreamDo: [ :stream | 
			stream nextPutAll: association value ] ]

]

{ #category : #running }
FOTTestWebSite >> setUpTemplates [

	templateDir := (srcDir / #templates) ensureCreateDirectory.
	
	(self class organization protocolNamed: #templates) methodSelectors do: [ :selector | | name |
		name := (selector endsWith: 'Template')
			ifTrue: [ selector allButLast: 8  ]
			ifFalse: [ selector ].
		(templateDir / name) writeStreamDo: [ :stream | 
			stream nextPutAll: (self perform: selector) ] ]

]

{ #category : #initialization }
FOTTestWebSite >> setUpWebSite [
	
	self setUpFileSystem.
	self setUpSources.
	self setUpTemplates.
	website := FOWebSite new.
	website 
		rawPath: srcDir;
		templatePath: templateDir.
]

{ #category : #initialization }
FOTTestWebSite >> setUpWebSiteDataWith: aDataString [
	
	dataFile := fs root / 'data'.
	dataFile writeStreamDo: [ :stream | stream nextPutAll: aDataString ].
	website dataPath: dataFile.
]
