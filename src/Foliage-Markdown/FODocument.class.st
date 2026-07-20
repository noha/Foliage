Class {
	#name : #FODocument,
	#superclass : #FOBlockNode,
	#instVars : [
		'children'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #initialization }
FODocument >> initialize [
	super initialize.
	children := OrderedCollection new
]

{ #category : #accessing }
FODocument >> children [
	^ children
]

{ #category : #adding }
FODocument >> addChild: aNode [
	children add: aNode
]

{ #category : #visiting }
FODocument >> acceptVisitor: aVisitor [
	^ aVisitor visitDocument: self
]
