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
	aClassification kind = #blockquote ifTrue: [ ^ self consumeBlockquote: aReader ].
	(aClassification kind = #unorderedListItem or: [ aClassification kind = #orderedListItem ])
		ifTrue: [ ^ self consumeList: aReader classification: aClassification ].
	^ self consumeParagraph: aReader
]

{ #category : #private }
FOMarkdownParser >> consumeHeader: aReader classification: aClassification [
	| trimmed text |
	trimmed := aReader next trimBoth.
	text := (trimmed copyFrom: aClassification level + 2 to: trimmed size) trimBoth.
	^ FOHeader new level: aClassification level; children: (FOInlineParser parse: text); yourself
]

{ #category : #private }
FOMarkdownParser >> consumeParagraph: aReader [
	| lines classification |
	lines := OrderedCollection new.
	[ aReader atEnd not and: [
		classification := FOLineClassifier classify: aReader peek.
		(#(#blank #atxHeader #fenceDelimiter #indentedCode #blockquote #unorderedListItem #orderedListItem) includes: classification kind) not ] ]
		whileTrue: [ lines add: aReader next trimBoth ].
	^ FOParagraph new children: (FOInlineParser parse: (self joinWithSpace: lines)); yourself
]

{ #category : #private }
FOMarkdownParser >> consumeBlockquote: aReader [
	| lines line |
	lines := OrderedCollection new.
	[ aReader atEnd not and: [ (FOLineClassifier classify: aReader peek) kind = #blockquote ] ]
		whileTrue: [
			line := aReader next trimBoth.
			lines add: (self stripBlockquoteMarker: line) ].
	^ FOBlockquote new children: (FOInlineParser parse: (self joinWithNewline: lines)); yourself
]

{ #category : #private }
FOMarkdownParser >> stripBlockquoteMarker: aLine [
	| rest |
	rest := aLine copyFrom: 2 to: aLine size.
	(rest notEmpty and: [ rest first = $  ])
		ifTrue: [ ^ rest copyFrom: 2 to: rest size ].
	^ rest
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
FOMarkdownParser >> consumeList: aReader classification: aClassification [
	| items ordered indent |
	ordered := aClassification ordered.
	indent := aClassification indent.
	items := OrderedCollection new.
	[ self atListItem: aReader ordered: ordered indent: indent ]
		whileTrue: [ items add: (self consumeListItem: aReader) ].
	^ FOList new ordered: ordered; items: items; yourself
]

{ #category : #private }
FOMarkdownParser >> atListItem: aReader ordered: aBoolean indent: anIndent [
	| c |
	aReader atEnd ifTrue: [ ^ false ].
	c := FOLineClassifier classify: aReader peek.
	^ (c kind = #unorderedListItem or: [ c kind = #orderedListItem ])
		and: [ c ordered = aBoolean and: [ c indent = anIndent ] ]
]

{ #category : #private }
FOMarkdownParser >> consumeListItem: aReader [
	| classification line text |
	classification := FOLineClassifier classify: aReader peek.
	line := aReader next.
	text := (line copyFrom: classification contentColumn + 1 to: line size) trimBoth.
	^ FOListItem new children: (FOInlineParser parse: text); yourself
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
