"
A link. The link text is held as inline children, so it can carry emphasis and
code. Foliage's own site: scheme is just another destination as far as the
parser is concerned.
"
Class {
	#name : #FOLink,
	#superclass : #FOInlineNode,
	#instVars : [
		'url',
		'title'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #visiting }
FOLink >> acceptVisitor: aVisitor [
	^ aVisitor visitLink: self
]

{ #category : #accessing }
FOLink >> title [
	^ title
]

{ #category : #accessing }
FOLink >> title: aString [
	title := aString
]

{ #category : #accessing }
FOLink >> url [
	^ url ifNil: [ '' ]
]

{ #category : #accessing }
FOLink >> url: aString [
	url := aString
]
