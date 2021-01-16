Class {
	#name : #FOWebFolder,
	#superclass : #FOWebResource,
	#instVars : [
		'children'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #accessing }
FOWebFolder >> / aString [ 
	^ children at: aString
]

{ #category : #visiting }
FOWebFolder >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitWebFolder: self 
]

{ #category : #accessing }
FOWebFolder >> allPages [
	^ children select: #isPage
]

{ #category : #accessing }
FOWebFolder >> atName: key put: value [
	(children includesKey: key)
		ifTrue: [ Error signal: 'child ', key asString, ' already exists' ].
	value parent: self.
	children
		at: key 
		put: value
]

{ #category : #'as yet unclassified' }
FOWebFolder >> atPath: aRelativePath add: aWebEntity [
	| container |
	container := self resolve: aRelativePath parent.
	container 
		atName: (aWebEntity publishPathFor: aRelativePath basename) 
		put: aWebEntity.
	^ aWebEntity  
]

{ #category : #accessing }
FOWebFolder >> children [
	^ children
]

{ #category : #'as yet unclassified' }
FOWebFolder >> createOnTarget [
	self publishPath ensureCreateDirectory 
]

{ #category : #'as yet unclassified' }
FOWebFolder >> gtInspectorItemsIn: composite [
	<gtInspectorPresentationOrder: 0>
	^ composite fastTable 
		title: 'Items';
		display: [ 
			self isRoot 
				ifTrue: [ children values ]
				ifFalse: [ 
					children values asOrderedCollection 
						addFirst: self parent;
						yourself ] ];
		column: 'Name' evaluated: [:each | (self isChildOf: each) 
			ifTrue: [ '..' ] 
			ifFalse: [ each name ]] width: 400
		
]

{ #category : #initialization }
FOWebFolder >> initialize [ 
	super initialize.
	children := SmallDictionary  new
]

{ #category : #testing }
FOWebFolder >> isRoot [
	^ false
]

{ #category : #accessing }
FOWebFolder >> name [
	^ parent nameOf: self
]

{ #category : #accessing }
FOWebFolder >> nameOf: aWebEntity [
	^ children keyAtValue: aWebEntity 
]

{ #category : #printing }
FOWebFolder >> printOn: aStream [
	aStream << self path asString << '/'
]

{ #category : #resolving }
FOWebFolder >> resolve: aRelativePath [ 
	| child |
	aRelativePath isEmpty ifTrue: [ 
		^ self ].
	child := children 
		at: aRelativePath segments first
		ifAbsentPut: [ 
			FOWebFolder new 
				parent: self ].
	^ child resolve: aRelativePath segments allButFirst 
]

{ #category : #accessing }
FOWebFolder >> setChildren: aCollection [ 
	children := aCollection 
]
