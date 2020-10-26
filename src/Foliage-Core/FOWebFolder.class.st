Class {
	#name : #FOWebFolder,
	#superclass : #FOWebResource,
	#instVars : [
		'children',
		'name'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #accessing }
FOWebFolder >> / aString [ 
	^ children 
		detect: [ :each | each name = aString ]
]

{ #category : #visiting }
FOWebFolder >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitWebFolder: self 
]

{ #category : #accessing }
FOWebFolder >> add: aWebItem [
	aWebItem parent: self.
	children add: aWebItem
]

{ #category : #accessing }
FOWebFolder >> allPages [
	^ children select: #isPage
]

{ #category : #accessing }
FOWebFolder >> children [
	^ children
]

{ #category : #accessing }
FOWebFolder >> children: anObject [
	children := anObject
]

{ #category : #'as yet unclassified' }
FOWebFolder >> gtInspectorItemsIn: composite [
	<gtInspectorPresentationOrder: 0>
	^ composite fastTable 
		title: 'Items';
		display: [ 
			self isRoot 
				ifTrue: [ children ]
				ifFalse: [ 
					children asOrderedCollection 
						addFirst: self parent;
						yourself ] ];
		column: 'Name' evaluated: [:each | (self isChildOf: each) 
			ifTrue: [ '..' ] 
			ifFalse: [ each name ]] width: 400
		
]

{ #category : #initialization }
FOWebFolder >> initialize [ 
	super initialize.
	children := OrderedCollection new
]

{ #category : #testing }
FOWebFolder >> isRoot [
	^ false
]

{ #category : #accessing }
FOWebFolder >> name [
	^ name
]

{ #category : #accessing }
FOWebFolder >> name: aString [ 
	name := aString
]

{ #category : #printing }
FOWebFolder >> printOn: aStream [
	aStream << name asString << '/'
]

{ #category : #resolving }
FOWebFolder >> resolve: aRelativePath [ 
	| child |
	aRelativePath isEmpty ifTrue: [ 
		^ self ].
	child := children
		detect: [ :each | each name = aRelativePath segments first ]
		ifNone: [ 
			FOWebFolder new 
				name: aRelativePath segments first;
				parent: self ].
	children add: child.
	^ child resolve: aRelativePath segments allButFirst 
]
