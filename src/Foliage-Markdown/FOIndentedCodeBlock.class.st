"
A code block written by indenting its lines with four spaces.
"
Class {
	#name : #FOIndentedCodeBlock,
	#superclass : #FOCodeBlock,
	#category : #'Foliage-Markdown'
}

{ #category : #parsing }
FOIndentedCodeBlock >> continueOn: aParser [
	| scanner |
	scanner := aParser scanner.
	scanner indent >= 4 ifTrue: [
		scanner advanceOffset: 4 columns: true.
		^ #matched ].
	scanner isBlank ifTrue: [
		scanner advanceNextNonspace.
		^ #matched ].
	^ #notMatched
]

{ #category : #parsing }
FOIndentedCodeBlock >> finalizeOn: aParser [
	"Trailing blank lines are not part of the code."
	self code: (FOSyntax stripTrailingBlankLines: self content) , (String with: Character lf)
]

{ #category : #accessing }
FOIndentedCodeBlock >> kind [
	^ #indented
]
