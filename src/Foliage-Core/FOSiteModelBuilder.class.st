Class {
	#name : #FOSiteModelBuilder,
	#superclass : #Object,
	#instVars : [
		'sourcePath',
		'targetPath',
		'templatePath',
		'website',
		'root'
	],
	#category : #'Foliage-Core'
}

{ #category : #accessing }
FOSiteModelBuilder class >> path: aString [
	^ self new
		path: aString asFileReference 
]

{ #category : #generation }
FOSiteModelBuilder >> build [
	| files document |
	files := website sourcePath allFiles select: [ :each | each extension = #md ].
	files do: [ :file |
		document := self buildDocument: file.
		self 
			writeDocument: document 
			to: (self targetFor: file)].
]

{ #category : #generation }
FOSiteModelBuilder >> build: sources [
	| container |
	sources do: [ :source |
		container := self resolveContainer: source path parent.
		container add: (source readFrom: (website rawPath resolve: source path))  ].
]

{ #category : #generation }
FOSiteModelBuilder >> buildDocument: aFileReference [ 
	| template body page | 
	page := self readPageFromFile: aFileReference.
	body := self renderPage: page.
	template := self templateFor: page layout.
	^ template value: { #body -> body } asDictionary . 
	
	
]

{ #category : #generation }
FOSiteModelBuilder >> readPageFromFile: aFileReference [ 
	| page |
	page := (FOPageReader on: aFileReference readStream) page.
	page path: (website relativeRawPath: aFileReference). 
	page validate.
	^ page
]

{ #category : #generation }
FOSiteModelBuilder >> renderPage: aPage [
	^ FOHTMLVisitor new 
		start: aPage pillar; 
		contents
]

{ #category : #resolving }
FOSiteModelBuilder >> resolveContainer: aRelativePath [ 
	^ self root resolve: aRelativePath segments
]

{ #category : #accessing }
FOSiteModelBuilder >> root [
	^ root ifNil: [ 
		root := FOWebsiteRoot new ]
]

{ #category : #generation }
FOSiteModelBuilder >> targetFor: aFileReference [
	| relativePath |
	relativePath := aFileReference withoutExtension 
		relativeTo: website sourcePath asAbsolute.
	^ website targetPath asAbsolute 
		resolve: (relativePath , #html)
]

{ #category : #templating }
FOSiteModelBuilder >> templateFor: aString [ 
	^ (website templatePath / aString) asMustacheTemplate 
]

{ #category : #accessing }
FOSiteModelBuilder >> website: aWebsite [ 
	website := aWebsite 
]

{ #category : #generation }
FOSiteModelBuilder >> writeDocument: aDocument to: aFileReference [
	aFileReference writeStream 
		truncate;
		nextPutAll: aDocument;
		flush;
		close
	
]
