Class {
	#name : #FOPublishVisitor,
	#superclass : #FOModelVisitor,
	#instVars : [
		'preview'
	],
	#category : #'Foliage-Core-Visitor'
}

{ #category : #accessing }
FOPublishVisitor >> bePreview [ 
	preview := true
]

{ #category : #visiting }
FOPublishVisitor >> copyResource: aResource [ 
	| target |
	target := aResource publishPath asFileReference.
	target exists ifTrue: [  target delete ].
	aResource sourcePath asFileReference copyTo: target
]

{ #category : #initialization }
FOPublishVisitor >> initialize [ 
	super initialize.
	preview := false.
]

{ #category : #accessing }
FOPublishVisitor >> templateForLayout: aString [ 
	self shouldBeImplemented.
]

{ #category : #visiting }
FOPublishVisitor >> visitBlog: aFOBlog [ 

	^ super visitWebFolder: aFOBlog
]

{ #category : #visiting }
FOPublishVisitor >> visitBlogPost: aFOBlogPost [ 
	^ (preview | aFOBlogPost isPublished) 
		ifTrue: [ self visitPillarPage: aFOBlogPost ]
		ifFalse: [ aFOBlogPost  ]
]

{ #category : #visiting }
FOPublishVisitor >> visitFileObject: aFileObject [ 
	aFileObject emit.
	self copyResource: aFileObject.
	^ aFileObject 
]

{ #category : #visiting }
FOPublishVisitor >> visitHTMLPageSource: aFOHTMLPageSource [ 
	aFOHTMLPageSource emit.
	self copyResource: aFOHTMLPageSource.
	^ aFOHTMLPageSource 
]

{ #category : #visiting }
FOPublishVisitor >> visitPillarPage: aFOPillarPage [ 
	aFOPillarPage emit.
	aFOPillarPage publish.
	^ aFOPillarPage 
]

{ #category : #visiting }
FOPublishVisitor >> visitRSSFeed: aFORSSFeed [ 
	| template targetPath stream |
	
	aFORSSFeed emit.
	template := (aFORSSFeed website templatePath / #'rss.xml') asMustacheTemplate.
	targetPath := aFORSSFeed publishPath asFileReference.
	stream := targetPath writeStream
		truncate;
		nextPutAll: (template value: aFORSSFeed);
		flush; 
		close.
	^ aFORSSFeed 
]

{ #category : #visiting }
FOPublishVisitor >> visitWebFolder: aFOWebsiteFolder [
	aFOWebsiteFolder emit.
	aFOWebsiteFolder createOnTarget.
	^ super visitWebFolder: aFOWebsiteFolder 
]

{ #category : #visiting }
FOPublishVisitor >> visitWebImage: aWebImage [ 
	aWebImage emit.
	self copyResource: aWebImage.
	^ aWebImage 
]
