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
							properties at: key asSymbol put: (self parseValue: value) ] ] ] ].
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
FOFrontmatterParser >> parseValue: aString [
	"A value that looks like '[a, b, c]' becomes a collection of trimmed,
	unquoted elements - generic (not tied to any specific key) so future
	multi-value frontmatter fields work without another parser change. No
	comma-escaping inside elements is supported, matching this parser's
	existing 'only what real content needs' scope."
	| trimmed inner |
	trimmed := aString trimBoth.
	(trimmed size >= 2 and: [ trimmed first = $[ and: [ trimmed last = $] ] ])
		ifFalse: [ ^ self stripQuotes: trimmed ].
	inner := (trimmed copyFrom: 2 to: trimmed size - 1) trimBoth.
	inner isEmpty ifTrue: [ ^ #() ].
	^ (inner substrings: ',') collect: [ :item | self stripQuotes: item trimBoth ]
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
