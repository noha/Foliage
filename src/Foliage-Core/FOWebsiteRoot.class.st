"
I represent the root of the web site.
I am build from `FOWebSite`.
"
Class {
	#name : #FOWebsiteRoot,
	#superclass : #FOWebFolder,
	#category : #'Foliage-Core-Model'
}

{ #category : #visiting }
FOWebsiteRoot >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitWebsiteRoot: self 
]

{ #category : #accessing }
FOWebsiteRoot >> defaultLayout [

	^ 'page'
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

{ #category : #accessing }
FOWebsiteRoot >> website [ 
	^ parent 
]
