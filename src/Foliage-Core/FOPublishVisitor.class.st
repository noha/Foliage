Class {
	#name : #FOPublishVisitor,
	#superclass : #FOModelVisitor,
	#category : #'Foliage-Core'
}

{ #category : #accessing }
FOPublishVisitor >> templateForLayout: aString [ 
	self shouldBeImplemented.
]

{ #category : #visiting }
FOPublishVisitor >> visitPageSource: aFOPageSource [ 
	| website targetPath stream html template page |
	website := aFOPageSource website.
	html := String streamContents: [ :s| 
		aFOPageSource renderOn: s ].
	template := (aFOPageSource website templatePathForLayout: aFOPageSource layout) asMustacheTemplate.
	page := template value: { #body -> html } asDictionary.
	targetPath := (website targetPathFor: aFOPageSource) withoutExtension, #html.
	targetPath parent ensureCreateDirectory.
	Transcript show: 'html: ', html asString; cr.
	Transcript show: 'page: ', page asString; cr.
	stream := targetPath writeStream
		truncate;
		nextPutAll: page;
		flush; 
		close.
	^ FOPageSource 
]

{ #category : #visiting }
FOPublishVisitor >> visitWebImage: aWebImage [ 
	| rawPath targetPath |
	rawPath := aWebImage website rawPathFor: aWebImage. 
	targetPath := aWebImage website targetPathFor: aWebImage.
	targetPath parent ensureCreateDirectory.
	targetPath exists ifFalse: [  
		rawPath copyTo: targetPath ]
]
