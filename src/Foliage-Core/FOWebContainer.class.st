Class {
	#name : #FOWebContainer,
	#superclass : #FOWebResource,
	#instVars : [
		'items'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #initialization }
FOWebContainer >> initialize [
	super initialize.
	items := Dictionary new
]

{ #category : #accessing }
FOWebContainer >> items [
	^ items
]

{ #category : #accessing }
FOWebContainer >> / aString [
	^ items at: aString
]

{ #category : #accessing }
FOWebContainer >> at: key put: value [
	(items includesKey: key)
		ifTrue: [ Error signal: 'child ', key asString, ' already exists' ].
	value parent: self.
	value name: key.
	items at: key put: value
]

{ #category : #accessing }
FOWebContainer >> allPages [
	^ items select: #isPage
]

{ #category : #accessing }
FOWebContainer >> setItems: aDictionary [
	aDictionary keysAndValuesDo: [ :key :value |
		value parent: self.
		value name: key ].
	items := aDictionary
]
