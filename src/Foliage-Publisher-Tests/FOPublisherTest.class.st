"
A FOPublisherTest is a test class for testing the behavior of FOPublisher
"
Class {
	#name : #FOPublisherTest,
	#superclass : #TestCase,
	#instVars : [
		'fs',
		'outputDir',
		'srcDir',
		'foliageConfigurationFile',
		'publisher'
	],
	#category : #'Foliage-Publisher-Tests'
}

{ #category : #templates }
FOPublisherTest >> headTemplate [ 

	^ '<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="shortcut icon" href="/files/favicon.ico" />
</head>'
]

{ #category : #templates }
FOPublisherTest >> pageTemplate [ 

	^ '<!DOCTYPE HTML>
<html>
    {{> head}}
    <body class="default">
        <div id="wrap">
            <div id="main">
              {{{body}}}
            </div>
        </div>
    </body>
</html>'
]

{ #category : #running }
FOPublisherTest >> setUp [
	super setUp.

	fs := FileSystem memory.
	srcDir := fs / 'src'.
	srcDir ensureCreateDirectory.
	outputDir := fs / 'generated'.
	foliageConfigurationFile := fs / '.foliage.ston'.
	self useMinimalFoliageConfiguration.
	self setUpTemplates.
	
	publisher := FOPublisher readFile: foliageConfigurationFile.
	publisher 
		sourcePath: srcDir;
		targetPath: outputDir.
]

{ #category : #running }
FOPublisherTest >> setUpTemplates [

	| templateDir |
	templateDir := (srcDir / #templates) ensureCreateDirectory.
	
	(self class organization protocolNamed: #templates) methodSelectors do: [ :selector | | name |
		name := (selector endsWith: 'Template')
			ifTrue: [ selector allButLast: 8  ]
			ifFalse: [ selector ].
		(templateDir / name) writeStreamDo: [ :stream | 
			stream nextPutAll: (self perform: selector) ] ]

]

{ #category : #'tests - input data' }
FOPublisherTest >> simpleMicrodownFile [

	^ String streamContents: [ :str |
		str 
			nextPutAll: '# Header 1'; cr;
			nextPutAll: '## Header 2'; cr;
			cr;
			nextPutAll: '- item A'; cr;
			nextPutAll: '- item B'; cr;
			nextPutAll: '- item C'; cr;
			nextPutAll: '# Another header 1'; cr;
			nextPutAll: 'Some paragraph with [a link](https://w3c.org).'; cr
	]
]

{ #category : #'tests - input data' }
FOPublisherTest >> simpleMicrodownFileWithMetaData [

	^ String streamContents: [ :str |
		str 
			nextPutAll: 'title: A simple md'; cr; cr;
			nextPutAll: self simpleMicrodownFile
	]
]

{ #category : #tests }
FOPublisherTest >> testCanPublishFromASimpleMicrodownFile [

	(srcDir / 'index.md') writeStreamDo: [ :stream | stream nextPutAll: self simpleMicrodownFileWithMetaData ].

	publisher publish.
	
	self assertCollection: outputDir fileNames equals: #( 'index.html' ).
	self 
		assert: (outputDir / 'index.html') contents
		equals: '<!DOCTYPE HTML>
<html>
    <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="shortcut icon" href="/files/favicon.ico" />
</head>
    <body class="default">
        <div id="wrap">
            <div id="main">
              <h1>Header 1</h1><h2>Header 2</h2><ul><li>item A</li><li>item B</li><li>item C</li></ul><h1>Another header 1</h1><p>Some paragraph with <a href="https://w3c.org">a link</a>.</p>
            </div>
        </div>
    </body>
</html>'
]

{ #category : #tests }
FOPublisherTest >> testCanPublishFromASimpleMicrodownFileWithYamlMetadataBlock [

	(srcDir / 'index.md') writeStreamDo: [ :stream | 
		stream 
			nextPutAll: '---'; cr;
			nextPutAll: 'title: Page with Yaml metadata block'; cr;
			nextPutAll: '---'; cr;
			nextPutAll: self simpleMicrodownFile ].

	publisher publish.
	
	self assertCollection: outputDir fileNames equals: #( 'index.html' ).
	self 
		assert: (outputDir / 'index.html') contents
		equals: '<!DOCTYPE HTML>
<html>
    <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="shortcut icon" href="/files/favicon.ico" />
</head>
    <body class="default">
        <div id="wrap">
            <div id="main">
              <h1>Header 1</h1><h2>Header 2</h2><ul><li>item A</li><li>item B</li><li>item C</li></ul><h1>Another header 1</h1><p>Some paragraph with <a href="https://w3c.org">a link</a>.</p>
            </div>
        </div>
    </body>
</html>'
]

{ #category : #tests }
FOPublisherTest >> testNoWarningRaisedWhenNoFoliageMetadataFound [

	(srcDir / 'index.md') writeStreamDo: [ :stream | stream nextPutAll: self simpleMicrodownFile ].

	publisher publish.
	
	self assert: outputDir fileNames equals: #('index.html').
]

{ #category : #tests }
FOPublisherTest >> testWarningRaisedWhenMissingMetadataSeparator [

	(srcDir / 'index.md') writeStreamDo: [ :stream | 
		stream 
			nextPutAll: 'title: A simple md'; cr;
			nextPutAll: self simpleMicrodownFile ].

	self 
		should: [ publisher publish ]
		raise: FoMetadataHeaderBadFormat
]

{ #category : #tests }
FOPublisherTest >> testWarningRaisedWhenMissingMetadataSeparatorWithYamlMetadataBlock [

	(srcDir / 'index.md') writeStreamDo: [ :stream | 
		stream 
			nextPutAll: '---'; cr;
			nextPutAll: 'title: A simple md'; cr;
			nextPutAll: self simpleMicrodownFile ].

	self 
		should: [ publisher publish ]
		raise: FoMetadataHeaderBadFormat
]

{ #category : #running }
FOPublisherTest >> useMinimalFoliageConfiguration [
	foliageConfigurationFile writeStreamDo: [ : stream |
		stream nextPutAll: 'Foliage {
	#baseUri: ''/''
}' ]
]
