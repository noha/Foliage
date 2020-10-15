Class {
	#name : #FOWebsiteRoot,
	#superclass : #FOWebBranch,
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
