Class {
	#name : #FOList,
	#superclass : #FOBlockNode,
	#instVars : [
		'ordered',
		'items'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #initialization }
FOList >> initialize [
	super initialize.
	items := OrderedCollection new
]

{ #category : #accessing }
FOList >> ordered [
	^ ordered
]

{ #category : #accessing }
FOList >> ordered: aBoolean [
	ordered := aBoolean
]

{ #category : #accessing }
FOList >> items [
	^ items
]

{ #category : #accessing }
FOList >> items: aCollection [
	items := aCollection
]

{ #category : #visiting }
FOList >> acceptVisitor: aVisitor [
	^ aVisitor visitList: self
]
