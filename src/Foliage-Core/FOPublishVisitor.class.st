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
	"we need to resolve path when filesystem store is a memory store"
	(aResource website rawPath parent resolvePath: aResource sourcePath) copyTo: target
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
	^ self visitPillarPage: aFOBlogPost 
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
