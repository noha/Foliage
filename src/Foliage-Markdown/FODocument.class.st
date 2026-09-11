"
The root of a parsed markdown document. Holds the top level blocks and, while
parsing, the map of link reference definitions collected from the source.
"
Class {
	#name : #FODocument,
	#superclass : #FOBlockNode,
	#instVars : [
		'linkReferences'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #visiting }
FODocument >> acceptVisitor: aVisitor [
	^ aVisitor visitDocument: self
]

{ #category : #testing }
FODocument >> canContain: aBlockNode [
	^ aBlockNode isListItem not
]

{ #category : #parsing }
FODocument >> continueOn: aParser [
	^ #matched
]

{ #category : #initialization }
FODocument >> initialize [
	super initialize.
	linkReferences := Dictionary new
]

{ #category : #accessing }
FODocument >> linkReferences [
	^ linkReferences
]
