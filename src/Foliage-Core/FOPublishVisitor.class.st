Class {
	#name : #FOPublishVisitor,
	#superclass : #FOModelVisitor,
	#category : #'Foliage-Core-Visitor'
}

{ #category : #visiting }
FOPublishVisitor >> copyResource: aResource [ 
	| rawPath targetPath |
	rawPath := aResource website rawPathFor: aResource. 
	targetPath := aResource realPublishPath.
	targetPath parent asFileReference exists ifFalse: [  
		targetPath parent asFileReference ensureCreateDirectory ].
	targetPath asFileReference exists ifFalse: [  
		rawPath copyTo: targetPath asFileReference ]
]

{ #category : #accessing }
FOPublishVisitor >> templateForLayout: aString [ 
	self shouldBeImplemented.
]

{ #category : #visiting }
FOPublishVisitor >> visitCSSObject: aFOCSSObject [ 
	self copyResource: aFOCSSObject 
]

{ #category : #visiting }
FOPublishVisitor >> visitHTMLPageSource: aFOHTMLPageSource [ 
	| targetPath rawPath |
	rawPath := aFOHTMLPageSource website rawPathFor: aFOHTMLPageSource.
 	targetPath := aFOHTMLPageSource website targetPathFor: aFOHTMLPageSource.
	targetPath parent ensureCreateDirectory.
	targetPath exists ifTrue: [
		targetPath delete ].
	rawPath copyTo: targetPath 
]

{ #category : #visiting }
FOPublishVisitor >> visitPillarPage: aFOPillarPage [ 
	| website targetPath stream html template page |
	website := aFOPillarPage website.
	html := String streamContents: [ :s| 
		aFOPillarPage renderOn: s ].
	template := (aFOPillarPage website templatePathForLayout: aFOPillarPage layout) asMustacheTemplate.
	page := template 
		value: { #body -> html } asDictionary
		partials: (FOPartialProvider new layout: aFOPillarPage layout; website: aFOPillarPage website).
	targetPath := aFOPillarPage realPublishPath asFileReference withoutExtension , #html.
	targetPath parent exists ifFalse: [  
		targetPath parent ensureCreateDirectory ].
	stream := targetPath writeStream
		truncate;
		nextPutAll: page;
		flush; 
		close.
	^ FOPageSource 
]

{ #category : #visiting }
FOPublishVisitor >> visitWebImage: aWebImage [ 
	self copyResource: aWebImage 
]
