Class {
	#name : #FOWebContainer,
	#superclass : #FOWebResource,
	#instVars : [
		'items'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #accessing }
FOWebContainer >> / aString [ 
	^ items at: aString
]

{ #category : #accessing }
FOWebContainer >> adaptValue: anObject [
	^ anObject isPage 
		ifTrue: [ self adaptPage: anObject ]
		ifFalse: [ self adaptResource: anObject ]
]

{ #category : #accessing }
FOWebContainer >> allPages [
	^ items select: #isPage
]

{ #category : #accessing }
FOWebContainer >> at: key put: value [
	(items includesKey: key)
		ifTrue: [ Error signal: 'child ', key asString, ' already exists' ].
	value parent: self.
	items
		at: key 
		put: (self adaptValue: value)
]

{ #category : #initialization }
FOWebContainer >> initialize [ 
	super initialize.
	items := SmallDictionary  new
]

{ #category : #accessing }
FOWebContainer >> items [
	^ items
]

{ #category : #accessing }
FOWebContainer >> nameOf: aWebEntity [
	^ items keyAtValue: aWebEntity 
]

{ #category : #'as yet unclassified' }
FOWebContainer >> setItems: aCollection [ 
	items := aCollection 
]
