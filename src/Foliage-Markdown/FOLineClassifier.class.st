Class {
	#name : #FOLineClassifier,
	#superclass : #Object,
	#category : #'Foliage-Markdown'
}

{ #category : #classifying }
FOLineClassifier class >> classify: aLine [
	| indent trimmed |
	indent := self indentOf: aLine.
	trimmed := aLine trimBoth.
	trimmed isEmpty ifTrue: [
		^ FOLineClassification new kind: #blank; indent: indent; yourself ].
	(self isHeader: trimmed) ifTrue: [
		^ self classifyHeader: trimmed indent: indent ].
	(self isFence: trimmed) ifTrue: [
		^ self classifyFence: trimmed indent: indent ].
	(self isBlockquote: trimmed) ifTrue: [
		^ FOLineClassification new kind: #blockquote; indent: indent; yourself ].
	(self isUnorderedListItem: trimmed) ifTrue: [
		^ self classifyList: trimmed indent: indent ordered: false ].
	(self isOrderedListItem: trimmed) ifTrue: [
		^ self classifyList: trimmed indent: indent ordered: true ].
	(self isImageLine: trimmed) ifTrue: [
		^ self classifyImage: trimmed indent: indent ].
	indent >= 4 ifTrue: [
		^ FOLineClassification new kind: #indentedCode; indent: indent; yourself ].
	^ FOLineClassification new kind: #paragraphText; indent: indent; yourself
]

{ #category : #private }
FOLineClassifier class >> indentOf: aLine [
	| i |
	i := 1.
	[ i <= aLine size and: [ (aLine at: i) = $  ] ] whileTrue: [ i := i + 1 ].
	^ i - 1
]

{ #category : #private }
FOLineClassifier class >> countLeading: aChar in: aLine [
	| i |
	i := 0.
	[ i < aLine size and: [ (aLine at: i + 1) = aChar ] ] whileTrue: [ i := i + 1 ].
	^ i
]

{ #category : #testing }
FOLineClassifier class >> isHeader: aLine [
	| hashes |
	hashes := self countLeading: $# in: aLine.
	^ (hashes between: 1 and: 6) and: [ hashes < aLine size and: [ (aLine at: hashes + 1) = $  ] ]
]

{ #category : #classifying }
FOLineClassifier class >> classifyHeader: aLine indent: anIndent [
	| level |
	level := self countLeading: $# in: aLine.
	^ FOLineClassification new kind: #atxHeader; indent: anIndent; level: level; yourself
]

{ #category : #testing }
FOLineClassifier class >> isFence: aLine [
	^ (self countLeading: $` in: aLine) >= 3
]

{ #category : #classifying }
FOLineClassifier class >> classifyFence: aLine indent: anIndent [
	| tickCount rest language |
	tickCount := self countLeading: $` in: aLine.
	rest := (aLine copyFrom: tickCount + 1 to: aLine size) trimBoth.
	language := (rest beginsWith: 'language=')
		ifTrue: [ rest copyFrom: 'language=' size + 1 to: rest size ]
		ifFalse: [ nil ].
	^ FOLineClassification new kind: #fenceDelimiter; indent: anIndent; language: language; yourself
]

{ #category : #testing }
FOLineClassifier class >> isBlockquote: aLine [
	^ aLine notEmpty and: [ (aLine at: 1) = $> ]
]

{ #category : #testing }
FOLineClassifier class >> isUnorderedListItem: aLine [
	^ aLine size >= 2 and: [ (aLine at: 1) = $- and: [ (aLine at: 2) = $  ] ]
]

{ #category : #testing }
FOLineClassifier class >> isOrderedListItem: aLine [
	| i |
	i := 1.
	[ i <= aLine size and: [ (aLine at: i) isDigit ] ] whileTrue: [ i := i + 1 ].
	^ i > 1 and: [ i + 1 <= aLine size and: [ (aLine at: i) = $. and: [ (aLine at: i + 1) = $  ] ] ]
]

{ #category : #classifying }
FOLineClassifier class >> classifyList: aLine indent: anIndent ordered: aBoolean [
	| markerLength |
	markerLength := aBoolean
		ifTrue: [ self orderedMarkerLength: aLine ]
		ifFalse: [ 2 ].
	^ FOLineClassification new
		kind: (aBoolean ifTrue: [ #orderedListItem ] ifFalse: [ #unorderedListItem ]);
		indent: anIndent;
		ordered: aBoolean;
		contentColumn: anIndent + markerLength;
		yourself
]

{ #category : #private }
FOLineClassifier class >> orderedMarkerLength: aLine [
	| i |
	i := 1.
	[ (aLine at: i) isDigit ] whileTrue: [ i := i + 1 ].
	^ i + 1
]

{ #category : #testing }
FOLineClassifier class >> isImageLine: aLine [
	^ (aLine beginsWith: '![') and: [ aLine notEmpty and: [ (aLine indexOf: $)) = aLine size ] ]
]

{ #category : #classifying }
FOLineClassifier class >> classifyImage: aLine indent: anIndent [
	| closeBracket inner spaceIndex src attributes attrString |
	closeBracket := aLine indexOf: $].
	inner := aLine copyFrom: closeBracket + 2 to: aLine size - 1.
	spaceIndex := inner indexOf: $ .
	attributes := Dictionary new.
	spaceIndex = 0
		ifTrue: [ src := inner ]
		ifFalse: [
			src := inner copyFrom: 1 to: spaceIndex - 1.
			attrString := (inner copyFrom: spaceIndex + 1 to: inner size) trimBoth.
			self parseAttributes: attrString into: attributes ].
	^ FOLineClassification new
		kind: #imageLine;
		indent: anIndent;
		alt: (aLine copyFrom: 3 to: closeBracket - 1);
		src: src;
		attributes: attributes;
		yourself
]

{ #category : #private }
FOLineClassifier class >> parseAttributes: aString into: aDictionary [
	(aString substrings: ' ') do: [ :pair |
		| eq |
		eq := pair indexOf: $=.
		eq = 0 ifFalse: [
			aDictionary
				at: (pair copyFrom: 1 to: eq - 1) asSymbol
				put: (pair copyFrom: eq + 1 to: pair size) ] ]
]
