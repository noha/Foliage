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
		put: value
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
	^ items 
		keyAtValue: aWebEntity 
		ifAbsent: [ Error signal: 'value not found' ]
]

{ #category : #'as yet unclassified' }
FOWebContainer >> setItems: aDictionary [ 
	aDictionary values do: [ :each | each parent: self ].
	items := aDictionary 
]
