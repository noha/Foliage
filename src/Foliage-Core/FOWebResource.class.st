Class {
	#name : #FOWebResource,
	#superclass : #Object,
	#instVars : [
		'parent'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #accessing }
FOWebResource class >> forFileExtension: aString [ 
	^ (FOWebEntity allSubclasses reject: #isAbstract)
		detect: [ :each | each matchesFileExtension: aString ]
		ifNone: [  nil ]
]

{ #category : #testing }
FOWebResource class >> isAbstract [ 
	^ self == FOWebResource 
]

{ #category : #accessing }
FOWebResource class >> matchesFileExtension: aString [ 
	^ self supportedFileExtensions includes: aString
]

{ #category : #testing }
FOWebResource >> isAbstract [ 
	^ self == FOWebResource 
]

{ #category : #testing }
FOWebResource >> isChildOf: anObject [
	^ self parent = anObject 
]

{ #category : #testing }
FOWebResource >> isPage [
	^ false
]

{ #category : #accessing }
FOWebResource >> parent [
	^ parent
]

{ #category : #accessing }
FOWebResource >> parent: anItem [
	parent := anItem
]

{ #category : #accessing }
FOWebResource >> root [ 	
	^ parent root
]

{ #category : #'as yet unclassified' }
FOWebResource >> website [ 
	^ self root website
]
