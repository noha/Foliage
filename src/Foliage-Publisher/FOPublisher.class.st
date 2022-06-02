Class {
	#name : #FOPublisher,
	#superclass : #Object,
	#instVars : [
		'baseUri',
		'targetPath',
		'sourcePath',
		'templatePath',
		'blogs'
	],
	#category : #'Foliage-Publisher'
}

{ #category : #'clap - commands' }
FOPublisher class >> clapPublish: args [
	
	self withErrorHandlingDo: [
		(self readFile: (args at: #project) value) publish ]
]

{ #category : #clap }
FOPublisher class >> commandLine [
	<commandline>
	
	^ (ClapCommand id: 'foliage')
		description: 'Foliage publisher';
		add: ClapFlag forHelp;
		add: ((ClapCommand id: 'publish')
			description: 'Publish foliage project';
			add: ClapFlag forHelp;
			add: ((ClapPositional id: 'project')
				implicitMeaning: [ self defaultProjectFileName ];
				description: 'STON file describing project (default .foliage.ston)';
				yourself);
			meaning: [ :args |
				args at: #helpFlag ifPresent: [ :help | 
					help value; exitSuccess ].
				self clapPublish: args ];
			yourself);
		meaning: [ :args | 
			args at: #helpFlag ifPresent: [ :help | 
				help value; exitSuccess ].
			args validateAll ];			
		yourself
]

{ #category : #'clap - defaults' }
FOPublisher class >> defaultProjectFileName [
		
	^ '.foliage.ston'
]

{ #category : #defaults }
FOPublisher class >> defaultSourcePath [

	^ '.'
]

{ #category : #defaults }
FOPublisher class >> defaultTargetPath [

	^ 'generated'
]

{ #category : #defaults }
FOPublisher class >> defaultTemplatePath [

	^ 'templates'
]

{ #category : #clap }
FOPublisher class >> readFile: aName [
	| reference |

	reference := aName asFileReference.
	reference exists ifFalse: [ 
		self error: ('File {1} does not exists' format: { reference fullName }) ].
	
	^ [ (STONReader on: reference readStream) next ]
		on: Error 
		do: [ :e | 
			self error: ('Error reading file {1}: {2}' 
				format: { reference fullName. e messageText }) ]
]

{ #category : #'ston-core' }
FOPublisher class >> stonName [

	^ #Foliage
]

{ #category : #clap }
FOPublisher class >> withErrorHandlingDo: aBlock [

	aBlock 
		on: Error 
		do: [ :e | 
			Stdio stderr << e messageText << OSPlatform current lineEnding.
			Exit signalFailure ]
]

{ #category : #accessing }
FOPublisher >> baseUri [

	^ baseUri
]

{ #category : #accessing }
FOPublisher >> baseUri: aString [

	baseUri := aString
]

{ #category : #accessing }
FOPublisher >> blogs [

	^ blogs
]

{ #category : #accessing }
FOPublisher >> blogs: anObject [

	blogs := anObject
]

{ #category : #actions }
FOPublisher >> publish [
	| site |

	site := FOWebSite new
		baseUri: self baseUri;
		targetPath: self targetPath asFileReference;
		rawPath: self sourcePath asFileReference;
		templatePath: self templatePath asFileReference.

	site importer readAll: site rawPath allFiles.

	self blogs do: [ :assoc | | blog |
		blog := (site / assoc key) convertToBlog.
		blog title: assoc value.
		blog 
    		at: #'index.html' put: blog overviewPage";
    		at: #'rss.xml' put: blog rssFeed.
		blog rssFeed addHeadersTo: blog / 'index.html'" ].
	
	site publish
		
]

{ #category : #accessing }
FOPublisher >> sourcePath [

	^ sourcePath ifNil: [ sourcePath := self class defaultSourcePath ]
]

{ #category : #accessing }
FOPublisher >> sourcePath: aString [

	sourcePath := aString
]

{ #category : #accessing }
FOPublisher >> targetPath [

	^ targetPath ifNil: [ targetPath := self class defaultTargetPath ]
]

{ #category : #accessing }
FOPublisher >> targetPath: aString [

	targetPath := aString
]

{ #category : #accessing }
FOPublisher >> templatePath [

	^ templatePath ifNil: [ templatePath := self class defaultTemplatePath ]
]

{ #category : #accessing }
FOPublisher >> templatePath: aString [

	templatePath := aString
]