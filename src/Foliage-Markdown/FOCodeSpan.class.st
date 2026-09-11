"
Inline code written between backticks. Its content is literal, so no other
inline construct is recognised inside it.
"
Class {
	#name : #FOCodeSpan,
	#superclass : #FOInlineNode,
	#instVars : [
		'code'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #visiting }
FOCodeSpan >> acceptVisitor: aVisitor [
	^ aVisitor visitCodeSpan: self
]

{ #category : #accessing }
FOCodeSpan >> code [
	^ code ifNil: [ '' ]
]

{ #category : #accessing }
FOCodeSpan >> code: aString [
	code := aString
]
