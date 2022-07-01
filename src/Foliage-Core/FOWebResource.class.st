Class {
	#name : #FOWebResource,
	#superclass : #Object,
	#instVars : [
		'parent',
		'properties'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #accessing }
FOWebResource class >> forFileExtension: aString [ 
	^ (FOFileBasedWebEntity allSubclasses reject: #isAbstract)
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

{ #category : #converting }
FOWebResource >> asBeaconSignal [

	^ FOObjectSignal new 
		object: self;
		slots: self emitSlots;
		selectors: self emitSelectors;
		yourself
]

{ #category : #layout }
FOWebResource >> defaultLayout [
	
	^ 'page'
]

{ #category : #copying }
FOWebResource >> duplicate [ 
	^ self copy resetParent
]

{ #category : #converting }
FOWebResource >> emitSelectors [
		
	^ #()
]

{ #category : #converting }
FOWebResource >> emitSlots [
		
	^ #()
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

{ #category : #accessing }
FOWebResource >> properties [ 
	^ properties ifNil: [ 
		properties := Dictionary new ]
]

{ #category : #accessing }
FOWebResource >> propertyAt: key [ 
	self properties at: key
]

{ #category : #accessing }
FOWebResource >> propertyAt: key ifAbsent: aBlock [
	self properties 
		at: key
		ifAbsent: aBlock
]

{ #category : #accessing }
FOWebResource >> propertyAt: key ifAbsentPut: aBlock [
	^ self properties 
		at: key
		ifAbsentPut: aBlock
]

{ #category : #accessing }
FOWebResource >> publishPath [
	self flag: #todo.
	"path is not properly defined. When there is raw path and when publich path?"
	^ self website targetPath resolvePath: self relativePath  
]

{ #category : #accessing }
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

{ #category : #accessing }
FOWebResource >> website [ 
	^ self root website
]
