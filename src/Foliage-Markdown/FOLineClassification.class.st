Class {
	#name : #FOLineClassification,
	#superclass : #Object,
	#instVars : [
		'kind',
		'indent',
		'level',
		'language',
		'ordered',
		'contentColumn',
		'alt',
		'src',
		'attributes'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #accessing }
FOLineClassification >> kind [
	^ kind
]

{ #category : #accessing }
FOLineClassification >> kind: aSymbol [
	kind := aSymbol
]

{ #category : #accessing }
FOLineClassification >> indent [
	^ indent
]

{ #category : #accessing }
FOLineClassification >> indent: anInteger [
	indent := anInteger
]

{ #category : #accessing }
FOLineClassification >> level [
	^ level
]

{ #category : #accessing }
FOLineClassification >> level: anInteger [
	level := anInteger
]

{ #category : #accessing }
FOLineClassification >> language [
	^ language
]

{ #category : #accessing }
FOLineClassification >> language: aStringOrNil [
	language := aStringOrNil
]

{ #category : #accessing }
FOLineClassification >> ordered [
	^ ordered
]

{ #category : #accessing }
FOLineClassification >> ordered: aBoolean [
	ordered := aBoolean
]

{ #category : #accessing }
FOLineClassification >> contentColumn [
	^ contentColumn
]

{ #category : #accessing }
FOLineClassification >> contentColumn: anInteger [
	contentColumn := anInteger
]

{ #category : #accessing }
FOLineClassification >> alt [
	^ alt
]

{ #category : #accessing }
FOLineClassification >> alt: aString [
	alt := aString
]

{ #category : #accessing }
FOLineClassification >> src [
	^ src
]

{ #category : #accessing }
FOLineClassification >> src: aString [
	src := aString
]

{ #category : #accessing }
FOLineClassification >> attributes [
	^ attributes
]

{ #category : #accessing }
FOLineClassification >> attributes: aDictionary [
	attributes := aDictionary
]
