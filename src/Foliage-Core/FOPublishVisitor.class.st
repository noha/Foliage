Class {
	#name : #FOPublishVisitor,
	#superclass : #FOModelVisitor,
	#category : #'Foliage-Core-Visitor'
}

{ #category : #actions }
FOPublishVisitor >> copyResource: aResource [
	| target |
	target := aResource publishPath asFileReference.
	target exists ifTrue: [ target delete ].
	aResource sourcePath asFileReference copyTo: target
]

{ #category : #visiting }
FOPublishVisitor >> visitBlog: aFOBlog [
	"FOBlog needs its own dispatch target since FOModelVisitor has no
	visitBlog: fallback pointing at visitWebFolder: (unlike visitWebsiteRoot:).
	Delegates to self (not super) visitWebFolder: deliberately - that's this
	class's own override, which does createOnTarget then the structural
	traversal; calling super would skip straight to FOModelVisitor's version
	and never create the blog's directory on disk at all, now that
	createOnTarget lives only in this class's override and not in the base
	visitor anymore."
	^ self visitWebFolder: aFOBlog
]

{ #category : #visiting }
FOPublishVisitor >> visitBlogPost: aFOBlogPost [
	^ self visitFoliagePage: aFOBlogPost
]

{ #category : #visiting }
FOPublishVisitor >> visitFileObject: aFileObject [
	self copyResource: aFileObject.
	^ aFileObject
]

{ #category : #visiting }
FOPublishVisitor >> visitHTMLPageSource: aFOHTMLPageSource [
	self copyResource: aFOHTMLPageSource.
	^ aFOHTMLPageSource
]

{ #category : #visiting }
FOPublishVisitor >> visitFoliagePage: aFOFoliagePage [
	aFOFoliagePage publish.
	^ aFOFoliagePage
]

{ #category : #visiting }
FOPublishVisitor >> visitRSSFeed: aFORSSFeed [
	| template |
	template := (aFORSSFeed website templatePath / #'rss.xml') asMustacheTemplate.
	aFORSSFeed publishPath
		ensureDelete;
		writeStreamDo: [ :stream | stream nextPutAll: (template value: aFORSSFeed) ].
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
