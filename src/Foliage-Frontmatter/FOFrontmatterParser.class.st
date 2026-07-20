Class {
	#name : #FOFrontmatterParser,
	#superclass : #Object,
	#category : #'Foliage-Frontmatter'
}

{ #category : #'instance creation' }
FOFrontmatterParser class >> parse: aString [
	^ self new parse: aString
]

{ #category : #parsing }
FOFrontmatterParser >> parse: aString [
	| lines properties bodyStartIndex line trimmed colonIndex key value |
	lines := aString lines.
	properties := Dictionary new.
	bodyStartIndex := nil.
	1 to: lines size do: [ :i |
		bodyStartIndex ifNil: [
			line := lines at: i.
			trimmed := line trimBoth.
			trimmed isEmpty
				ifTrue: [ bodyStartIndex := i + 1 ]
				ifFalse: [
					colonIndex := line indexOf: $:.
					(colonIndex = 0 or: [ (self isValidKey: (line copyFrom: 1 to: colonIndex - 1)) not ])
						ifTrue: [ bodyStartIndex := i ]
						ifFalse: [
							key := (line copyFrom: 1 to: colonIndex - 1) trimBoth.
							value := (line copyFrom: colonIndex + 1 to: line size) trimBoth.
							properties at: key asSymbol put: (self stripQuotes: value) ] ] ] ].
	^ FOFrontmatter
		properties: properties
		body: (bodyStartIndex isNil
			ifTrue: [ '' ]
			ifFalse: [ self joinLines: (lines copyFrom: bodyStartIndex to: lines size) ])
]

{ #category : #private }
FOFrontmatterParser >> isValidKey: aSubstring [
	| trimmed |
	trimmed := aSubstring trimBoth.
	^ trimmed isEmpty not and: [ (trimmed anySatisfy: [ :c | c isSeparator ]) not ]
]

{ #category : #private }
FOFrontmatterParser >> stripQuotes: aString [
	(aString size >= 2 and: [ aString first = $" and: [ aString last = $" ] ])
		ifTrue: [ ^ aString copyFrom: 2 to: aString size - 1 ].
	^ aString
]

{ #category : #private }
FOFrontmatterParser >> joinLines: aCollection [
	^ String streamContents: [ :s |
		aCollection
			do: [ :l | s nextPutAll: l ]
			separatedBy: [ s nextPut: Character lf ] ]
]
