Class {
	#name : #FOMarkdownParser,
	#superclass : #Object,
	#category : #'Foliage-Markdown'
}

{ #category : #'instance creation' }
FOMarkdownParser class >> parse: aString [
	^ self new parse: aString
]

{ #category : #parsing }
FOMarkdownParser >> parse: aString [
	| reader document classification |
	reader := FOLineReader on: aString.
	document := FODocument new.
	[ reader atEnd ] whileFalse: [
		classification := FOLineClassifier classify: reader peek.
		classification kind = #blank
			ifTrue: [ reader next ]
			ifFalse: [
				classification kind = #atxHeader
					ifTrue: [ document addChild: (self consumeHeader: reader classification: classification) ]
					ifFalse: [ document addChild: (self consumeParagraph: reader) ] ] ].
	^ document
]

{ #category : #private }
FOMarkdownParser >> consumeHeader: aReader classification: aClassification [
	| trimmed text |
	trimmed := aReader next trimBoth.
	text := (trimmed copyFrom: aClassification level + 2 to: trimmed size) trimBoth.
	^ FOHeader new level: aClassification level; text: text; yourself
]

{ #category : #private }
FOMarkdownParser >> consumeParagraph: aReader [
	| lines classification |
	lines := OrderedCollection new.
	[ aReader atEnd not and: [
		classification := FOLineClassifier classify: aReader peek.
		classification kind ~= #blank and: [ classification kind ~= #atxHeader ] ] ]
		whileTrue: [ lines add: aReader next trimBoth ].
	^ FOParagraph new text: (self joinWithSpace: lines); yourself
]

{ #category : #private }
FOMarkdownParser >> joinWithSpace: aCollection [
	^ String streamContents: [ :s |
		aCollection
			do: [ :l | s nextPutAll: l ]
			separatedBy: [ s nextPut: $  ] ]
]
