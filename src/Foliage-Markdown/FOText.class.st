"
A run of literal text. The string is the already unescaped source text; escaping
for the output format is the renderer's job.
"
Class {
	#name : #FOText,
	#superclass : #FOInlineNode,
	#instVars : [
		'string'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #visiting }
FOText >> acceptVisitor: aVisitor [
	^ aVisitor visitText: self
]

{ #category : #testing }
FOText >> isText [
	^ true
]

{ #category : #accessing }
FOText >> string [
	^ string ifNil: [ '' ]
]

{ #category : #accessing }
FOText >> string: aString [
	string := aString
]
