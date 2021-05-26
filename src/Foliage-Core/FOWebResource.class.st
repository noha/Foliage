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

{ #category : #accessing }
FOWebResource >> absoluteLink [
	^ self website absoluteLinkFor: self 
]

{ #category : #'as yet unclassified' }
FOWebResource >> adaptPage: aFOPage [ 
	^ aFOPage 
]

{ #category : #'as yet unclassified' }
FOWebResource >> adaptResource: aFOResource [
	^ aFOResource 
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

{ #category : #testing }
FOWebResource >> isPost [
	^ false
]

{ #category : #'instance creation' }
FOWebResource >> newRenderContext [ 
	^ self renderContextClass new 
		website: self website
]

{ #category : #accessing }
FOWebResource >> parent [
	^ parent
]

{ #category : #accessing }
FOWebResource >> parent: anItem [
	parent ifNotNil: [ Error signal: anItem asString, ' is already added to the tree' ].
	parent := anItem
]

{ #category : #accessing }
FOWebResource >> path [
	^ parent path / (parent nameOf: self)
]

{ #category : #accessing }
FOWebResource >> pathString [
	^ (self path withExtension: #html) pathString
]

{ #category : #'as yet unclassified' }
FOWebResource >> publishPath [
	self flag: #todo.
	"path is not properly defined. When there is raw path and when publich path?"
	^ self website targetPath resolve: self relativePath  
]

{ #category : #'as yet unclassified' }
FOWebResource >> publishPathFor: aString [ 
	^ aString
]

{ #category : #accessing }
FOWebResource >> relativePath [
	^ self path relativeTo: '/' asPath
]

{ #category : #'instance creation' }
FOWebResource >> renderContextClass [
	^ FORenderContext
]

{ #category : #accessing }
FOWebResource >> resetParent [
	parent := nil
]

{ #category : #accessing }
FOWebResource >> root [ 	
	^ parent root
]

{ #category : #'as yet unclassified' }
FOWebResource >> website [ 
	^ self root website
]
