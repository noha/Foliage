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
FOPublishVisitor >> visitWebFolder: aFOWebsiteFolder [
	aFOWebsiteFolder createOnTarget.
	^ super visitWebFolder: aFOWebsiteFolder
]

{ #category : #visiting }
FOPublishVisitor >> visitWebImage: aWebImage [
	self copyResource: aWebImage.
	^ aWebImage
]
