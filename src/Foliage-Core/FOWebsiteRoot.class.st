Class {
	#name : #FOWebsiteRoot,
	#superclass : #FOWebFolder,
	#category : #'Foliage-Core'
}

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
