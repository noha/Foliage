Class {
	#name : #FOPublishVisitor,
	#superclass : #FOModelVisitor,
	#category : #'Foliage-Core-Visitor'
}

{ #category : #visiting }
FOPublishVisitor >> copyResource: aResource [ 
	| target |
	target := aResource publishPath asFileReference.
	target exists ifTrue: [  target delete ].
	aResource sourcePath asFileReference copyTo: target
]

{ #category : #accessing }
FOPublishVisitor >> templateForLayout: aString [ 
	self shouldBeImplemented.
]

{ #category : #visiting }
FOPublishVisitor >> visitBlog: aFOBlog [ 
	^ super visitWebFolder: aFOBlog.
]

{ #category : #'as yet unclassified' }
FOPublishVisitor >> visitBlogPost: aFOBlogPost [ 
	^ self visitPillarPage: aFOBlogPost 
]

{ #category : #visiting }
FOPublishVisitor >> visitCSSObject: aFOCSSObject [ 
	self copyResource: aFOCSSObject.
	^ aFOCSSObject 
]

{ #category : #visiting }
FOPublishVisitor >> visitHTMLPageSource: aFOHTMLPageSource [ 
	self copyResource: aFOHTMLPageSource.
	^ aFOHTMLPageSource 
]

{ #category : #visiting }
FOPublishVisitor >> visitPillarPage: aFOPillarPage [ 
	aFOPillarPage publish.
	^ aFOPillarPage 
]

{ #category : #'as yet unclassified' }
FOPublishVisitor >> visitRSSFeed: aFORSSFeed [ 
	| template targetPath stream |
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
	aFOWebsiteFolder createOnTarget.
	^ super visitWebFolder: aFOWebsiteFolder 
]

{ #category : #visiting }
FOPublishVisitor >> visitWebImage: aWebImage [ 
	self copyResource: aWebImage.
	^ aWebImage 
]
