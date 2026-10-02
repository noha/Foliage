"
A paragraph. While the document is read it collects raw lines; once the block
structure is known those lines are turned into inline nodes. Link reference
definitions at the start of a paragraph are stripped off and registered with the
document instead.
"
Class {
	#name : #FOParagraph,
	#superclass : #FOBlockNode,
	#category : #'Foliage-Markdown'
}

{ #category : #visiting }
FOParagraph >> acceptVisitor: aVisitor [
	^ aVisitor visitParagraph: self
]

{ #category : #testing }
FOParagraph >> acceptsLines [
	^ true
]

{ #category : #parsing }
FOParagraph >> continueOn: aParser [
	^ aParser scanner isBlank
		ifTrue: [ #notMatched ]
		ifFalse: [ #matched ]
]

{ #category : #parsing }
FOParagraph >> finalizeOn: aParser [
	| consumed sawDefinition |
	sawDefinition := false.
	[ self content notEmpty
		and: [ self content first = $[
		and: [ consumed := aParser consumeLinkReferenceFrom: self content.
			consumed > 0 ] ] ]
		whileTrue: [
			sawDefinition := true.
			self content: (self content allButFirst: consumed) ].
	(sawDefinition and: [ FOSyntax isBlank: self content ])
		ifTrue: [ self unlink ]
]

{ #category : #testing }
FOParagraph >> holdsInlines [
	^ true
]

{ #category : #testing }
FOParagraph >> isParagraph [
	^ true
]
