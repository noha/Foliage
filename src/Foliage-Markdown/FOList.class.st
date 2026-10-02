"
An ordered or unordered list. Its children are FOListItems. A list is tight when
no blank line separates its items or their contents; a tight list renders its
item paragraphs without <p> wrappers.
"
Class {
	#name : #FOList,
	#superclass : #FOBlockNode,
	#instVars : [
		'listData'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #visiting }
FOList >> acceptVisitor: aVisitor [
	^ aVisitor visitList: self
]

{ #category : #testing }
FOList >> blankLineTravelsToLastChild [
	^ true
]

{ #category : #testing }
FOList >> canContain: aBlockNode [
	^ aBlockNode isListItem
]

{ #category : #parsing }
FOList >> continueOn: aParser [
	^ #matched
]

{ #category : #parsing }
FOList >> finalizeOn: aParser [
	"A blank line anywhere between the items, or between the blocks of an item
	 that is not the last one, makes the whole list loose."
	self children do: [ :item |
		(item endsWithBlankLine and: [ item nextSibling notNil ])
			ifTrue: [ ^ listData tight: false ].
		item children do: [ :sub |
			(sub endsWithBlankLine and: [ item nextSibling notNil or: [ sub nextSibling notNil ] ])
				ifTrue: [ ^ listData tight: false ] ] ]
]

{ #category : #initialization }
FOList >> initialize [
	super initialize.
	listData := FOListData new
]

{ #category : #testing }
FOList >> isList [
	^ true
]

{ #category : #accessing }
FOList >> items [
	"A list's children are its items; #items is the name the domain uses."
	^ self children
]

{ #category : #accessing }
FOList >> listData [
	^ listData
]

{ #category : #accessing }
FOList >> listData: aListData [
	listData := aListData
]

{ #category : #accessing }
FOList >> ordered [
	^ listData ordered
]

{ #category : #accessing }
FOList >> ordered: aBoolean [
	listData ordered: aBoolean
]

{ #category : #accessing }
FOList >> start [
	^ listData start
]

{ #category : #accessing }
FOList >> tight [
	^ listData tight
]
