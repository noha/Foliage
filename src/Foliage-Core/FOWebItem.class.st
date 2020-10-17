Class {
	#name : #FOWebItem,
	#superclass : #Object,
	#instVars : [
		'parent'
	],
	#category : #'Foliage-Core'
}

{ #category : #accessing }
FOWebItem class >> forFileExtension: aString [ 
	^ (FOWebLeaf allSubclasses reject: #isAbstract)
		detect: [ :each | each matchesFileExtension: aString ]
		ifNone: [  nil ]
]

{ #category : #testing }
FOWebItem class >> isAbstract [ 
	^ self == FOWebItem 
]

{ #category : #accessing }
FOWebItem class >> matchesFileExtension: aString [ 
	^ self supportedFileExtensions includes: aString
]

{ #category : #testing }
FOWebItem >> isAbstract [ 
	^ self == FOWebItem 
]

{ #category : #testing }
FOWebItem >> isChildOf: anObject [
	^ self parent = anObject 
]

{ #category : #accessing }
FOWebItem >> parent [
	^ parent
]

{ #category : #accessing }
FOWebItem >> parent: anItem [
	parent := anItem
]

{ #category : #accessing }
FOWebItem >> root [ 	
	^ parent root
]

{ #category : #'as yet unclassified' }
FOWebItem >> website [ 
	^ self root website
]
