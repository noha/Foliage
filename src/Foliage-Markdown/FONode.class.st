"
Abstract superclass of every markdown AST node. Nodes form a tree: each knows its
parent and its children, which lets the parsers move whole ranges of nodes around
while emphasis and links are being resolved.

Nodes are visited with the double-dispatch protocol #acceptVisitor:.
"
Class {
	#name : #FONode,
	#superclass : #Object,
	#instVars : [
		'parent',
		'children'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #visiting }
FONode >> acceptVisitor: aVisitor [
	^ self subclassResponsibility
]

{ #category : #adding }
FONode >> addChild: aNode [
	aNode parent ifNotNil: [ aNode unlink ].
	children add: aNode.
	aNode parent: self.
	^ aNode
]

{ #category : #adding }
FONode >> addChild: aNode after: anotherNode [
	| index |
	index := children indexOf: anotherNode.
	children add: aNode afterIndex: index.
	aNode parent: self.
	^ aNode
]

{ #category : #accessing }
FONode >> children [
	^ children
]

{ #category : #accessing }
FONode >> children: aCollection [
	children := aCollection asOrderedCollection.
	children do: [ :each | each parent: self ]
]

{ #category : #accessing }
FONode >> firstChild [
	^ children isEmpty ifTrue: [ nil ] ifFalse: [ children first ]
]

{ #category : #initialization }
FONode >> initialize [
	super initialize.
	children := OrderedCollection new
]

{ #category : #testing }
FONode >> isBlock [
	^ false
]

{ #category : #testing }
FONode >> isInline [
	^ false
]

{ #category : #testing }
FONode >> isText [
	^ false
]

{ #category : #accessing }
FONode >> lastChild [
	^ children isEmpty ifTrue: [ nil ] ifFalse: [ children last ]
]

{ #category : #accessing }
FONode >> nextSibling [
	| index |
	parent ifNil: [ ^ nil ].
	index := parent children indexOf: self.
	^ index < parent children size
		ifTrue: [ parent children at: index + 1 ]
		ifFalse: [ nil ]
]

{ #category : #accessing }
FONode >> parent [
	^ parent
]

{ #category : #accessing }
FONode >> parent: aNode [
	parent := aNode
]

{ #category : #removing }
FONode >> unlink [
	parent ifNotNil: [ :owner | owner children remove: self ifAbsent: [ ] ].
	parent := nil
]
