Class {
	#name : #FOWebBranch,
	#superclass : #FOWebItem,
	#instVars : [
		'children',
		'name'
	],
	#category : #'Foliage-Core'
}

{ #category : #accessing }
FOWebBranch >> add: aWebItem [
	aWebItem parent: self.
	children add: aWebItem
]

{ #category : #'as yet unclassified' }
FOWebBranch >> gtInspectorItemsIn: composite [
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
FOWebBranch >> initialize [ 
	super initialize.
	children := OrderedCollection new
]

{ #category : #testing }
FOWebBranch >> isRoot [
	^ false
]

{ #category : #accessing }
FOWebBranch >> name [
	^ name
]

{ #category : #accessing }
FOWebBranch >> name: aString [ 
	name := aString
]

{ #category : #resolving }
FOWebBranch >> resolve: aRelativePath [ 
	| child |
	aRelativePath isEmpty ifTrue: [ 
		^ self ].
	child := children
		detect: [ :each | each name = aRelativePath first ]
		ifNone: [ 
			FOWebBranch new 
				name: aRelativePath first;
				parent: self ].
	children add: child.
	^ child resolve: aRelativePath allButFirst 
]
