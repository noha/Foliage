Class {
	#name : #FOPublishVisitor,
	#superclass : #FOModelVisitor,
	#category : #'Foliage-Core'
}

{ #category : #visiting }
FOPublishVisitor >> copyResource: aResource [ 
	| rawPath targetPath |
	rawPath := aResource website rawPathFor: aResource. 
	targetPath := aResource website targetPathFor: aResource.
	targetPath parent ensureCreateDirectory.
	targetPath exists ifFalse: [  
		rawPath copyTo: targetPath ]
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
FOPublishVisitor >> visitPageSource: aFOPageSource [ 
	| website targetPath stream html template page |
	website := aFOPageSource website.
	html := String streamContents: [ :s| 
		aFOPageSource renderOn: s ].
	template := (aFOPageSource website templatePathForLayout: aFOPageSource layout) asMustacheTemplate.
	page := template 
		value: { #body -> html } asDictionary
		partials: (FOPartialProvider new layout: aFOPageSource layout; website: aFOPageSource website).
	targetPath := (website targetPathFor: aFOPageSource) withoutExtension, #html.
	targetPath parent ensureCreateDirectory.
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
