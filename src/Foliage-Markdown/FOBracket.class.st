"
An unresolved [ or ![ on the bracket stack of the inline parser. When a ] is
found the topmost bracket says where the link text started, whether it belongs to
an image, and which delimiters were on the stack before it - everything needed to
turn the range into a link or image node.

#active is cleared on the enclosing brackets once a link is built, because links
may not nest.
"
Class {
	#name : #FOBracket,
	#superclass : #Object,
	#instVars : [
		'node',
		'previous',
		'previousDelimiter',
		'index',
		'image',
		'active',
		'bracketAfter'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #accessing }
FOBracket >> active [
	^ active
]

{ #category : #accessing }
FOBracket >> active: aBoolean [
	active := aBoolean
]

{ #category : #accessing }
FOBracket >> bracketAfter [
	^ bracketAfter
]

{ #category : #accessing }
FOBracket >> bracketAfter: aBoolean [
	bracketAfter := aBoolean
]

{ #category : #accessing }
FOBracket >> image [
	^ image
]

{ #category : #accessing }
FOBracket >> image: aBoolean [
	image := aBoolean
]

{ #category : #accessing }
FOBracket >> index [
	^ index
]

{ #category : #accessing }
FOBracket >> index: anInteger [
	index := anInteger
]

{ #category : #initialization }
FOBracket >> initialize [
	super initialize.
	active := true.
	image := false.
	bracketAfter := false
]

{ #category : #accessing }
FOBracket >> node [
	^ node
]

{ #category : #accessing }
FOBracket >> node: aNode [
	node := aNode
]

{ #category : #accessing }
FOBracket >> previous [
	^ previous
]

{ #category : #accessing }
FOBracket >> previous: aBracket [
	previous := aBracket
]

{ #category : #accessing }
FOBracket >> previousDelimiter [
	^ previousDelimiter
]

{ #category : #accessing }
FOBracket >> previousDelimiter: aDelimiter [
	previousDelimiter := aDelimiter
]
