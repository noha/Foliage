Class {
	#name : #FOLink,
	#superclass : #FOInlineNode,
	#instVars : [
		'text',
		'url'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #accessing }
FOLink >> text [
	^ text
]

{ #category : #accessing }
FOLink >> text: aString [
	text := aString
]

{ #category : #accessing }
FOLink >> url [
	^ url
]

{ #category : #accessing }
FOLink >> url: aString [
	url := aString
]

{ #category : #visiting }
FOLink >> acceptVisitor: aVisitor [
	^ aVisitor visitLink: self
]
