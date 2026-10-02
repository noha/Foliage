"
One run of * or _ on the delimiter stack the inline parser keeps while it reads a
line. Whether a run can open or close emphasis is decided when it is scanned; the
matching itself happens afterwards in FOInlineParser>>processEmphasisFrom:.

The entries form a doubly linked list, so the matching pass can walk forward to
the next closer and back to the nearest opener and cut out everything in between.
"
Class {
	#name : #FODelimiter,
	#superclass : #Object,
	#instVars : [
		'character',
		'count',
		'originalCount',
		'node',
		'previous',
		'next',
		'canOpen',
		'canClose'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #accessing }
FODelimiter >> canClose [
	^ canClose
]

{ #category : #accessing }
FODelimiter >> canClose: aBoolean [
	canClose := aBoolean
]

{ #category : #accessing }
FODelimiter >> canOpen [
	^ canOpen
]

{ #category : #accessing }
FODelimiter >> canOpen: aBoolean [
	canOpen := aBoolean
]

{ #category : #accessing }
FODelimiter >> character [
	^ character
]

{ #category : #accessing }
FODelimiter >> character: aCharacter [
	character := aCharacter
]

{ #category : #accessing }
FODelimiter >> count [
	^ count
]

{ #category : #accessing }
FODelimiter >> count: anInteger [
	count := anInteger
]

{ #category : #accessing }
FODelimiter >> next [
	^ next
]

{ #category : #accessing }
FODelimiter >> next: aDelimiter [
	next := aDelimiter
]

{ #category : #accessing }
FODelimiter >> node [
	^ node
]

{ #category : #accessing }
FODelimiter >> node: aNode [
	node := aNode
]

{ #category : #accessing }
FODelimiter >> originalCount [
	^ originalCount
]

{ #category : #accessing }
FODelimiter >> originalCount: anInteger [
	originalCount := anInteger
]

{ #category : #accessing }
FODelimiter >> previous [
	^ previous
]

{ #category : #accessing }
FODelimiter >> previous: aDelimiter [
	previous := aDelimiter
]
