Class {
	#name : #FOListItem,
	#superclass : #FOBlockNode,
	#instVars : [
		'children',
		'nestedList'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #accessing }
FOListItem >> children [
	^ children
]

{ #category : #accessing }
FOListItem >> children: aCollection [
	children := aCollection
]

{ #category : #accessing }
FOListItem >> nestedList [
	^ nestedList
]

{ #category : #accessing }
FOListItem >> nestedList: aFOList [
	nestedList := aFOList
]

{ #category : #visiting }
FOListItem >> acceptVisitor: aVisitor [
	^ aVisitor visitListItem: self
]
