Class {
	#name : #FOWebsiteRoot,
	#superclass : #FOWebFolder,
	#category : #'Foliage-Core-Model'
}

{ #category : #visiting }
FOWebsiteRoot >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitWebsiteRoot: self 
]

{ #category : #adding }
FOWebsiteRoot >> addResource: aResource [
	| container |
	container := self resolve: aResource path parent.
	container add: aResource
]

{ #category : #testing }
FOWebsiteRoot >> isRoot [
	^ true
]

{ #category : #accessing }
FOWebsiteRoot >> name [ 
	^ #/
]

{ #category : #accessing }
FOWebsiteRoot >> path [ 
	^ Path root
]

{ #category : #accessing }
FOWebsiteRoot >> root [ 	
	^ self 
]

{ #category : #'as yet unclassified' }
FOWebsiteRoot >> website [ 
	^ parent 
]
