Class {
	#name : #FOPages,
	#superclass : #Object,
	#instVars : [
		'page',
		'sourcePath',
		'targetPath',
		'templatePath'
	],
	#category : #'Foliage-Core'
}

{ #category : #accessing }
FOPages class >> path: aString [
	^ self new
		path: aString asFileReference 
]

{ #category : #generation }
FOPages >> generate [
	| files document |
	files := sourcePath allFiles select: [ :each | each extension = #md ].
	files do: [ :file |
		document := self generateDocument: file.
		self 
			writeDocument: document 
			to: (self targetFor: file)].
]

{ #category : #generation }
FOPages >> generateDocument: aFileReference [ 
	| template body |
	page := self readPageFromFile: aFileReference.
	body := self renderPage: page.
	template := self templateFor: page layout.
	^ template value: { #body -> body } asDictionary . 
	
	
]

{ #category : #generation }
FOPages >> readPageFromFile: aFileReference [
	page := (FOPageReader on: aFileReference readStream) page.
	page hasDocumentType ifFalse: [ 
		Error signal: 'document in ', aFileReference asString, ' is missing type' ].
	^ page
]

{ #category : #generation }
FOPages >> renderPage: aPage [
	^ FOHTMLVisitor new 
		start: aPage pillar; 
		contents
]

{ #category : #accessing }
FOPages >> sourcePath: aString [ 
	sourcePath := aString asFileReference 
]

{ #category : #generation }
FOPages >> targetFor: aFileReference [
	| relativePath |
	relativePath := aFileReference withoutExtension 
		relativeTo: sourcePath asAbsolute.
	^ targetPath asAbsolute 
		resolve: (relativePath , #html)
]

{ #category : #accessing }
FOPages >> targetPath: aString [ 
	targetPath := aString asFileReference 
]

{ #category : #templating }
FOPages >> templateFor: aString [ 
	^ (templatePath / aString) asMustacheTemplate 
]

{ #category : #accessing }
FOPages >> templatePath: aString [ 
	templatePath := aString asFileReference 
]

{ #category : #generation }
FOPages >> writeDocument: aDocument to: aFileReference [
	aFileReference writeStream 
		truncate;
		nextPutAll: aDocument;
		flush;
		close
	
]
