"
The marker information of a list item: which marker was used, how wide it is and
where the item content starts. A list and each of its items carry one, and two
of them ""match"" when the items belong to the same list.
"
Class {
	#name : #FOListData,
	#superclass : #Object,
	#instVars : [
		'ordered',
		'start',
		'tight',
		'bulletChar',
		'delimiter',
		'padding',
		'markerOffset'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #accessing }
FOListData >> bulletChar [
	^ bulletChar
]

{ #category : #accessing }
FOListData >> bulletChar: aCharacter [
	bulletChar := aCharacter
]

{ #category : #accessing }
FOListData >> delimiter [
	^ delimiter
]

{ #category : #accessing }
FOListData >> delimiter: aCharacter [
	delimiter := aCharacter
]

{ #category : #initialization }
FOListData >> initialize [
	super initialize.
	ordered := false.
	tight := true.
	padding := 0.
	markerOffset := 0
]

{ #category : #accessing }
FOListData >> markerOffset [
	^ markerOffset
]

{ #category : #accessing }
FOListData >> markerOffset: anInteger [
	markerOffset := anInteger
]

{ #category : #testing }
FOListData >> matches: anotherListData [
	"Two items belong to the same list when they use the same kind of marker."
	^ ordered = anotherListData ordered
		and: [ ordered
			ifTrue: [ delimiter = anotherListData delimiter ]
			ifFalse: [ bulletChar = anotherListData bulletChar ] ]
]

{ #category : #accessing }
FOListData >> ordered [
	^ ordered
]

{ #category : #accessing }
FOListData >> ordered: aBoolean [
	ordered := aBoolean
]

{ #category : #accessing }
FOListData >> padding [
	^ padding
]

{ #category : #accessing }
FOListData >> padding: anInteger [
	padding := anInteger
]

{ #category : #accessing }
FOListData >> start [
	^ start
]

{ #category : #accessing }
FOListData >> start: anInteger [
	start := anInteger
]

{ #category : #accessing }
FOListData >> tight [
	^ tight
]

{ #category : #accessing }
FOListData >> tight: aBoolean [
	tight := aBoolean
]
