Class {
	#name : #FOCodeBlock,
	#superclass : #FOBlockNode,
	#instVars : [
		'code',
		'language',
		'kind'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #accessing }
FOCodeBlock >> code [
	^ code
]

{ #category : #accessing }
FOCodeBlock >> code: aString [
	code := aString
]

{ #category : #accessing }
FOCodeBlock >> language [
	^ language
]

{ #category : #accessing }
FOCodeBlock >> language: aStringOrNil [
	language := aStringOrNil
]

{ #category : #accessing }
FOCodeBlock >> kind [
	^ kind
]

{ #category : #accessing }
FOCodeBlock >> kind: aSymbol [
	kind := aSymbol
]

{ #category : #visiting }
FOCodeBlock >> acceptVisitor: aVisitor [
	^ aVisitor visitCodeBlock: self
]
