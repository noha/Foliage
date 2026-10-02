"
An image. Its children are the inline nodes of the description, from which the
alt attribute is rendered.

Beyond CommonMark, Foliage lets an author put HTML attributes after the
destination, as in ![alt](/images/x.svg class=u-max-full-width); they end up in
#attributes and are written out on the img element.
"
Class {
	#name : #FOImage,
	#superclass : #FOInlineNode,
	#instVars : [
		'src',
		'title',
		'attributes'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #visiting }
FOImage >> acceptVisitor: aVisitor [
	^ aVisitor visitImage: self
]

{ #category : #accessing }
FOImage >> attributes [
	^ attributes
]

{ #category : #accessing }
FOImage >> attributes: aDictionary [
	attributes := aDictionary
]

{ #category : #initialization }
FOImage >> initialize [
	super initialize.
	attributes := Dictionary new
]

{ #category : #accessing }
FOImage >> src [
	^ src ifNil: [ '' ]
]

{ #category : #accessing }
FOImage >> src: aString [
	src := aString
]

{ #category : #accessing }
FOImage >> title [
	^ title
]

{ #category : #accessing }
FOImage >> title: aString [
	title := aString
]
