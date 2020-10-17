Class {
	#name : #FOModelVisitor,
	#superclass : #Object,
	#category : #'Foliage-Core'
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
FOModelVisitor >> visitMicrodownPageSource: aFOMicroDownPageSource [ 
	^ self visitPageSource: aFOMicroDownPageSource 
]

{ #category : #visiting }
FOModelVisitor >> visitPageSource: aFOPageSource [ 
	^ self visitWebObject: aFOPageSource 
]

{ #category : #visiting }
FOModelVisitor >> visitWebBinaryObject: aFOWebBinaryObject [
	^ self visitWebObject: aFOWebBinaryObject 
]

{ #category : #visiting }
FOModelVisitor >> visitWebFolder: aFOWebsiteFolder [
	^ (self visitWebResource: aFOWebsiteFolder)
		children: (self visitAll: aFOWebsiteFolder children );
		yourself 
]

{ #category : #visiting }
FOModelVisitor >> visitWebImage: aWebImage [ 
	^ self visitWebBinaryObject: aWebImage 
]

{ #category : #visiting }
FOModelVisitor >> visitWebObject: aFOWebObject [
	^ self visitWebResource: aFOWebObject 
]

{ #category : #visiting }
FOModelVisitor >> visitWebResource: aFOWebObject [
	^ aFOWebObject copy
]

{ #category : #visiting }
FOModelVisitor >> visitWebsiteRoot: aFOWebsiteRoot [ 
	^ self visitWebFolder: aFOWebsiteRoot 
]
