Class {
	#name : #FOModelVisitor,
	#superclass : #Object,
	#category : #'Foliage-Core-Visitor'
}

{ #category : #visiting }
FOModelVisitor >> start: anObject [ 
	^ self visit: anObject
]

{ #category : #visiting }
FOModelVisitor >> visit: anObject [
	^ anObject acceptFOVisitor: self
]

{ #category : #visiting }
FOModelVisitor >> visitAll: aCollection [ 
	^ aCollection collect: [ :each |
		self visit: each ]
]

{ #category : #visiting }
FOModelVisitor >> visitHTMLPageSource: aFOHTMLPageSource [ 
	^ self visitPageSource: aFOHTMLPageSource 
]

{ #category : #visiting }
FOModelVisitor >> visitPageSource: aFOPageSource [ 
	^ self visitWebEntity: aFOPageSource 
]

{ #category : #visiting }
FOModelVisitor >> visitWebBinaryEntity: aFOWebBinaryObject [
	^ self visitWebEntity: aFOWebBinaryObject 
]

{ #category : #visiting }
FOModelVisitor >> visitWebEntity: aFOWebObject [
	^ self visitWebResource: aFOWebObject 
]

{ #category : #visiting }
FOModelVisitor >> visitWebFolder: aFOWebsiteFolder [
	aFOWebsiteFolder createOnTarget.
	^ (self visitWebResource: aFOWebsiteFolder)
		setItems: (self visitAll: aFOWebsiteFolder items );
		yourself 
]

{ #category : #visiting }
FOModelVisitor >> visitWebImage: aWebImage [ 
	^ self visitWebBinaryEntity: aWebImage 
]

{ #category : #visiting }
FOModelVisitor >> visitWebResource: aFOWebObject [
	aFOWebObject emit.
	^ aFOWebObject copy
]

{ #category : #visiting }
FOModelVisitor >> visitWebsite: aFOWebsite [ 
	^ self visit: aFOWebsite root
]

{ #category : #visiting }
FOModelVisitor >> visitWebsiteRoot: aFOWebsiteRoot [ 
	^ self visitWebFolder: aFOWebsiteRoot 
]
