Class {
	#name : #FOWebResource,
	#superclass : #Object,
	#instVars : [
		'parent',
		'properties',
		'name'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #accessing }
FOWebResource >> name [
	^ name
]

{ #category : #accessing }
FOWebResource >> name: aString [
	name := aString
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
	^ parent path / self name
]

{ #category : #accessing }
FOWebResource >> pathString [
	^ (self path withExtension: #html) pathString
]

{ #category : #accessing }
FOWebResource >> relativePath [
	^ self path relativeTo: '/' asPath
]

{ #category : #accessing }
FOWebResource >> publishPath [
	"Mirrors contentPath 1:1 by default (content/foo.md -> output/foo.html); pages that
	need a different output path (e.g. a generated blog overview page) override
	this."
	^ self website outputPath resolvePath: self relativePath
]

{ #category : #accessing }
FOWebResource >> properties [
	^ properties ifNil: [ properties := Dictionary new ]
]

{ #category : #accessing }
FOWebResource >> propertyAt: key [
	^ self properties at: key
]

{ #category : #accessing }
FOWebResource >> propertyAt: key ifAbsent: aBlock [
	^ self properties at: key ifAbsent: aBlock
]

{ #category : #accessing }
FOWebResource >> propertyAt: key ifAbsentPut: aBlock [
	^ self properties at: key ifAbsentPut: aBlock
]

{ #category : #accessing }
FOWebResource >> root [
	^ parent root
]

{ #category : #accessing }
FOWebResource >> website [
	^ self root website
]

{ #category : #accessing }
FOWebResource >> absoluteLink [
	^ self website absoluteLinkFor: self
]

{ #category : #layout }
FOWebResource >> defaultLayout [
	^ 'page'
]

{ #category : #'instance creation' }
FOWebResource >> renderContextClass [
	^ FORenderContext
]

{ #category : #'instance creation' }
FOWebResource >> newRenderContext [
	^ self renderContextClass new
		website: self website
]

{ #category : #copying }
FOWebResource >> duplicate [
	^ self copy resetParent
]

{ #category : #accessing }
FOWebResource >> resetParent [
	parent := nil
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
