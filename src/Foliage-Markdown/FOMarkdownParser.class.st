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
	| reader document classification block |
	reader := FOLineReader on: aString.
	document := FODocument new.
	[ reader atEnd ] whileFalse: [
		classification := FOLineClassifier classify: reader peek.
		block := self consumeBlock: reader classification: classification.
		block ifNotNil: [ document addChild: block ] ].
	^ document
]

{ #category : #private }
FOMarkdownParser >> consumeBlock: aReader classification: aClassification [
	aClassification kind = #blank ifTrue: [ aReader next. ^ nil ].
	aClassification kind = #atxHeader ifTrue: [ ^ self consumeHeader: aReader classification: aClassification ].
	aClassification kind = #fenceDelimiter ifTrue: [ ^ self consumeFencedCode: aReader classification: aClassification ].
	aClassification kind = #indentedCode ifTrue: [ ^ self consumeIndentedCode: aReader ].
	^ self consumeParagraph: aReader
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
		(#(#blank #atxHeader #fenceDelimiter #indentedCode) includes: classification kind) not ] ]
		whileTrue: [ lines add: aReader next trimBoth ].
	^ FOParagraph new text: (self joinWithSpace: lines); yourself
]

{ #category : #private }
FOMarkdownParser >> consumeFencedCode: aReader classification: aClassification [
	| lines |
	aReader next.
	lines := OrderedCollection new.
	[ aReader atEnd not and: [ (FOLineClassifier classify: aReader peek) kind ~= #fenceDelimiter ] ]
		whileTrue: [ lines add: aReader next ].
	aReader atEnd ifFalse: [ aReader next ].
	^ FOCodeBlock new
		kind: #fenced;
		language: aClassification language;
		code: (self joinWithNewline: lines);
		yourself
]

{ #category : #private }
FOMarkdownParser >> consumeIndentedCode: aReader [
	| lines line |
	lines := OrderedCollection new.
	[ aReader atEnd not and: [ (FOLineClassifier classify: aReader peek) kind = #indentedCode ] ]
		whileTrue: [
			line := aReader next.
			lines add: (aReader stripIndent: 4 from: line) ].
	^ FOCodeBlock new
		kind: #indented;
		language: nil;
		code: (self joinWithNewline: lines);
		yourself
]

{ #category : #private }
FOMarkdownParser >> joinWithSpace: aCollection [
	^ String streamContents: [ :s |
		aCollection
			do: [ :l | s nextPutAll: l ]
			separatedBy: [ s nextPut: $  ] ]
]

{ #category : #private }
FOMarkdownParser >> joinWithNewline: aCollection [
	^ String streamContents: [ :s |
		aCollection
			do: [ :l | s nextPutAll: l ]
			separatedBy: [ s nextPut: Character lf ] ]
]
