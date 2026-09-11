"
One item of a list. Its children are blocks, so an item can hold several
paragraphs, nested lists, code blocks and quotes.
"
Class {
	#name : #FOListItem,
	#superclass : #FOBlockNode,
	#instVars : [
		'listData'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #testing }
FOListItem >> absorbsBlankLine: aLineNumber [
	"A blank line right after the marker of a still empty item belongs to it."
	^ self firstChild isNil and: [ self startLine = aLineNumber ]
]

{ #category : #visiting }
FOListItem >> acceptVisitor: aVisitor [
	^ aVisitor visitListItem: self
]

{ #category : #testing }
FOListItem >> blankLineTravelsToLastChild [
	^ true
]

{ #category : #testing }
FOListItem >> canContain: aBlockNode [
	^ aBlockNode isListItem not
]

{ #category : #parsing }
FOListItem >> continueOn: aParser [
	| scanner |
	scanner := aParser scanner.
	scanner isBlank
		ifTrue: [
			"A blank line directly after the marker leaves the item empty and ends it."
			self firstChild ifNil: [ ^ #notMatched ].
			scanner advanceNextNonspace ]
		ifFalse: [
			scanner indent >= (listData markerOffset + listData padding)
				ifFalse: [ ^ #notMatched ].
			scanner advanceOffset: listData markerOffset + listData padding columns: true ].
	^ #matched
]

{ #category : #initialization }
FOListItem >> initialize [
	super initialize.
	listData := FOListData new
]

{ #category : #testing }
FOListItem >> isListItem [
	^ true
]

{ #category : #accessing }
FOListItem >> listData [
	^ listData
]

{ #category : #accessing }
FOListItem >> listData: aListData [
	listData := aListData
]
