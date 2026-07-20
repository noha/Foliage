Class {
	#name : #FOImage,
	#superclass : #FOInlineNode,
	#instVars : [
		'alt',
		'src',
		'attributes'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #initialization }
FOImage >> initialize [
	super initialize.
	attributes := Dictionary new
]

{ #category : #accessing }
FOImage >> alt [
	^ alt
]

{ #category : #accessing }
FOImage >> alt: aString [
	alt := aString
]

{ #category : #accessing }
FOImage >> src [
	^ src
]

{ #category : #accessing }
FOImage >> src: aString [
	src := aString
]

{ #category : #accessing }
FOImage >> attributes [
	^ attributes
]

{ #category : #accessing }
FOImage >> attributes: aDictionary [
	attributes := aDictionary
]

{ #category : #visiting }
FOImage >> acceptVisitor: aVisitor [
	^ aVisitor visitImage: self
]
