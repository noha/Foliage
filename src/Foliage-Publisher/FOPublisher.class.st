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

{ #category : #defaults }
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

{ #category : #'instance creation' }
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
	^ blogs ifNil: [ #() ]
]

{ #category : #accessing }
FOPublisher >> blogs: anObject [
	blogs := anObject
]

{ #category : #actions }
FOPublisher >> publish [
	"blogPaths is set upfront (before import), so a blog folder is already an
	FOBlog by the time the importer reaches it - no post-hoc convertToBlog
	needed anymore, just setting the title on the (already blog-typed) folder
	once import is done."
	| site allFiles |
	site := FOWebSite new
		baseUri: self baseUri;
		targetPath: self targetPath asFileReference;
		rawPath: self sourcePath asFileReference;
		templatePath: self sourcePath asFileReference / self templatePath;
		blogPaths: (self blogs collect: [ :assoc | assoc key asString ]);
		yourself.
	allFiles := site rawPath allFiles.
	site importer readAll: allFiles.
	self blogs do: [ :assoc |
		| blog seriesFolder |
		blog := site / assoc key.
		blog title: assoc value.
		blog overviewPages doWithIndex: [ :page :i |
			blog at: (FOBlogOverviewBuilder pageFilenameFor: i) put: page ].
		blog at: #'rss.xml' put: blog rssFeed.
		blog series ifNotEmpty: [
			seriesFolder := blog resolvePath: (RelativePath from: 'series').
			seriesFolder at: #'index.html' put: (FOSeriesIndexBuilder new blog: blog; buildPage).
			blog series do: [ :aSeries |
				seriesFolder
					at: (aSeries slug, '.html') asSymbol
					put: (FOSeriesOverviewBuilder new blog: blog; series: aSeries; buildPage) ] ] ].
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
