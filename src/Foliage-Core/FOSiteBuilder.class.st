Class {
	#name : #FOSiteBuilder,
	#superclass : #Object,
	#instVars : [
		'sourcePath',
		'targetPath',
		'templatePath',
		'website'
	],
	#category : #'Foliage-Core'
}

{ #category : #accessing }
FOSiteBuilder class >> path: aString [
	^ self new
		path: aString asFileReference 
]

{ #category : #generation }
FOSiteBuilder >> build [
	| files document |
	files := website sourcePath allFiles select: [ :each | each extension = #md ].
	files do: [ :file |
		document := self buildDocument: file.
		self 
			writeDocument: document 
			to: (self targetFor: file)].
]

{ #category : #generation }
FOSiteBuilder >> buildDocument: aFileReference [ 
	| template body page | 
	page := self readPageFromFile: aFileReference.
	body := self renderPage: page.
	template := self templateFor: page layout.
	^ template value: { #body -> body } asDictionary . 
	
	
]

{ #category : #generation }
FOSiteBuilder >> readPageFromFile: aFileReference [ 
	| page |
	page := (FOPageReader on: aFileReference readStream) page.
	page validate.
	^ page
]

{ #category : #generation }
FOSiteBuilder >> renderPage: aPage [
	^ FOHTMLVisitor new 
		start: aPage pillar; 
		contents
]

{ #category : #generation }
FOSiteBuilder >> targetFor: aFileReference [
	| relativePath |
	relativePath := aFileReference withoutExtension 
		relativeTo: website sourcePath asAbsolute.
	^ website targetPath asAbsolute 
		resolve: (relativePath , #html)
]

{ #category : #templating }
FOSiteBuilder >> templateFor: aString [ 
	^ (website templatePath / aString) asMustacheTemplate 
]

{ #category : #accessing }
FOSiteBuilder >> website: aWebsite [ 
	website := aWebsite 
]

{ #category : #generation }
FOSiteBuilder >> writeDocument: aDocument to: aFileReference [
	aFileReference writeStream 
		truncate;
		nextPutAll: aDocument;
		flush;
		close
	
]
