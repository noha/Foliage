Class {
	#name : #FOWebsiteRoot,
	#superclass : #FOWebFolder,
	#category : #'Foliage-Core'
}

{ #category : #visiting }
FOWebsiteRoot >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitWebsiteRoot: self 
]

{ #category : #testing }
FOWebsiteRoot >> isRoot [
	^ true
]

{ #category : #accessing }
FOWebsiteRoot >> root [ 	
	^ self 
]

{ #category : #'as yet unclassified' }
FOWebsiteRoot >> website [ 
	^ parent 
]
