"
The character and line level predicates of the CommonMark grammar, gathered in
one place so the block and inline parsers can share them. All methods are on the
class side; the class is never instantiated.
"
Class {
	#name : #FOSyntax,
	#superclass : #Object,
	#category : #'Foliage-Markdown'
}

{ #category : #'testing - characters' }
FOSyntax class >> isSpaceOrTab: aCharacterOrNil [
	^ aCharacterOrNil notNil
		and: [ aCharacterOrNil = $  or: [ aCharacterOrNil = Character tab ] ]
]

{ #category : #'testing - characters' }
FOSyntax class >> isUnicodeWhitespace: aCharacterOrNil [
	"A character of the Unicode Zs category, or tab, line feed, form feed or
	 carriage return. The non-breaking space counts, which is why it cannot flank
	 emphasis."
	| value |
	aCharacterOrNil ifNil: [ ^ false ].
	value := aCharacterOrNil asInteger.
	(value = 16r09 or: [ value = 16r0A or: [ value = 16r0C or: [ value = 16r0D ] ] ])
		ifTrue: [ ^ true ].
	^ self unicodeSpaceSeparators includes: value
]

{ #category : #'testing - characters' }
FOSyntax class >> unicodeSpaceSeparators [
	"The code points of the Unicode Zs general category."
	^ #( 16r0020 16r00A0 16r1680 16r2000 16r2001 16r2002 16r2003 16r2004 16r2005
	16r2006 16r2007 16r2008 16r2009 16r200A 16r202F 16r205F 16r3000 )
]

{ #category : #'testing - characters' }
FOSyntax class >> isAsciiWhitespace: aCharacterOrNil [
	"Space, tab, line feed, form feed or carriage return. Link destinations end at
	 these, but not at other Unicode spaces."
	| value |
	aCharacterOrNil ifNil: [ ^ false ].
	value := aCharacterOrNil asInteger.
	^ value = 16r20 or: [ value between: 16r09 and: 16r0D ]
]

{ #category : #'testing - characters' }
FOSyntax class >> isAsciiSpaceOrControl: aCharacterOrNil [
	"The characters a link destination may not contain literally."
	| value |
	aCharacterOrNil ifNil: [ ^ false ].
	value := aCharacterOrNil asInteger.
	^ value <= 16r20 or: [ value = 16r7F ]
]

{ #category : #'testing - characters' }
FOSyntax class >> isAsciiPunctuation: aCharacterOrNil [
	aCharacterOrNil ifNil: [ ^ false ].
	^ '!"#$%&''()*+,-./:;<=>?@[\]^_`{|}~' includes: aCharacterOrNil
]

{ #category : #'testing - characters' }
FOSyntax class >> isPunctuation: aCharacterOrNil [
	"ASCII punctuation, plus any non-ASCII character that is neither a letter,
	 a digit nor whitespace - a workable stand-in for the Unicode punctuation
	 categories the spec names."
	aCharacterOrNil ifNil: [ ^ false ].
	(self isAsciiPunctuation: aCharacterOrNil) ifTrue: [ ^ true ].
	aCharacterOrNil asInteger < 128 ifTrue: [ ^ false ].
	^ (aCharacterOrNil isLetter or: [ aCharacterOrNil isDigit ]) not
		and: [ (self isUnicodeWhitespace: aCharacterOrNil) not ]
]

{ #category : #'testing - characters' }
FOSyntax class >> isEscapable: aCharacterOrNil [
	^ self isAsciiPunctuation: aCharacterOrNil
]

{ #category : #'testing - lines' }
FOSyntax class >> isBlank: aString [
	^ aString allSatisfy: [ :each |
		each = $  or: [ each = Character tab
			or: [ each = Character lf or: [ each = Character cr or: [ each = Character newPage ] ] ] ] ]
]

{ #category : #'testing - lines' }
FOSyntax class >> isThematicBreak: aString [
	| marker count |
	marker := nil.
	count := 0.
	aString do: [ :each |
		(self isSpaceOrTab: each)
			ifFalse: [
				('*-_' includes: each) ifFalse: [ ^ false ].
				marker ifNil: [ marker := each ].
				each = marker ifFalse: [ ^ false ].
				count := count + 1 ] ].
	^ count >= 3
]

{ #category : #'testing - lines' }
FOSyntax class >> setextLevelOf: aString [
	"Answer 1 for an underline of =, 2 for one of -, otherwise nil."
	| end marker |
	end := aString size.
	[ end > 0 and: [ self isSpaceOrTab: (aString at: end) ] ] whileTrue: [ end := end - 1 ].
	end = 0 ifTrue: [ ^ nil ].
	marker := aString first.
	(marker = $= or: [ marker = $- ]) ifFalse: [ ^ nil ].
	1 to: end do: [ :i | (aString at: i) = marker ifFalse: [ ^ nil ] ].
	^ marker = $= ifTrue: [ 1 ] ifFalse: [ 2 ]
]

{ #category : #'testing - lines' }
FOSyntax class >> atxMarkerLengthIn: aString [
	"Answer how many characters the opening #s and the whitespace after them take,
	 or 0 when the string does not start an ATX heading."
	| hashes i |
	hashes := 0.
	[ hashes < aString size and: [ (aString at: hashes + 1) = $# ] ]
		whileTrue: [ hashes := hashes + 1 ].
	(hashes between: 1 and: 6) ifFalse: [ ^ 0 ].
	hashes = aString size ifTrue: [ ^ hashes ].
	(self isSpaceOrTab: (aString at: hashes + 1)) ifFalse: [ ^ 0 ].
	i := hashes.
	[ i < aString size and: [ self isSpaceOrTab: (aString at: i + 1) ] ]
		whileTrue: [ i := i + 1 ].
	^ i
]

{ #category : #'testing - lines' }
FOSyntax class >> atxContentOf: aString [
	"Strip an optional closing run of #s from the text of an ATX heading."
	| trimmed i j |
	trimmed := aString.
	i := trimmed size.
	[ i > 0 and: [ self isSpaceOrTab: (trimmed at: i) ] ] whileTrue: [ i := i - 1 ].
	j := i.
	[ j > 0 and: [ (trimmed at: j) = $# ] ] whileTrue: [ j := j - 1 ].
	j = i ifTrue: [ ^ trimmed first: i ].
	j = 0 ifTrue: [ ^ '' ].
	(self isSpaceOrTab: (trimmed at: j)) ifFalse: [ ^ trimmed first: i ].
	[ j > 0 and: [ self isSpaceOrTab: (trimmed at: j) ] ] whileTrue: [ j := j - 1 ].
	^ trimmed first: j
]

{ #category : #'testing - lines' }
FOSyntax class >> openingFenceLengthIn: aString [
	"Answer the length of an opening code fence at the start of aString, or 0.
	 A backtick fence may not have another backtick anywhere on its line."
	| fenceChar count |
	aString isEmpty ifTrue: [ ^ 0 ].
	fenceChar := aString first.
	(fenceChar = $` or: [ fenceChar = $~ ]) ifFalse: [ ^ 0 ].
	count := 0.
	[ count < aString size and: [ (aString at: count + 1) = fenceChar ] ]
		whileTrue: [ count := count + 1 ].
	count < 3 ifTrue: [ ^ 0 ].
	(fenceChar = $` and: [ (aString allButFirst: count) includes: $` ]) ifTrue: [ ^ 0 ].
	^ count
]

{ #category : #'testing - lines' }
FOSyntax class >> closingFenceLengthIn: aString from: anIndex char: aFenceChar [
	"Answer the length of a closing fence of aFenceChar starting at anIndex, or 0.
	 Only spaces may follow it."
	| i count |
	i := anIndex.
	count := 0.
	[ i <= aString size and: [ (aString at: i) = aFenceChar ] ]
		whileTrue: [ count := count + 1. i := i + 1 ].
	count < 3 ifTrue: [ ^ 0 ].
	[ i <= aString size ] whileTrue: [
		(aString at: i) = $  ifFalse: [ ^ 0 ].
		i := i + 1 ].
	^ count
]

{ #category : #'testing - lines' }
FOSyntax class >> bulletMarkerIn: aString [
	"Answer the bullet character starting aString, or nil."
	aString isEmpty ifTrue: [ ^ nil ].
	^ ('*+-' includes: aString first) ifTrue: [ aString first ] ifFalse: [ nil ]
]

{ #category : #'testing - lines' }
FOSyntax class >> orderedMarkerIn: aString [
	"Answer an Array with the number, the delimiter character and the marker
	 length for an ordered list marker at the start of aString, or nil."
	| digits |
	digits := 0.
	[ digits < aString size and: [ (aString at: digits + 1) isDigit ] ]
		whileTrue: [ digits := digits + 1 ].
	(digits between: 1 and: 9) ifFalse: [ ^ nil ].
	digits >= aString size ifTrue: [ ^ nil ].
	((aString at: digits + 1) = $. or: [ (aString at: digits + 1) = $) ])
		ifFalse: [ ^ nil ].
	^ Array
		with: (aString first: digits) asInteger
		with: (aString at: digits + 1)
		with: digits + 1
]

{ #category : #'string operations' }
FOSyntax class >> stripTrailingBlankLines: aString [
	"Remove the trailing run of line endings and the spaces between them."
	| end i |
	end := aString size.
	[ true ] whileTrue: [
		i := end.
		[ i > 0 and: [ (aString at: i) = $  ] ] whileTrue: [ i := i - 1 ].
		(i > 0 and: [ (aString at: i) = Character lf ])
			ifTrue: [ end := i - 1 ]
			ifFalse: [ ^ aString first: end ] ]
]

{ #category : #'string operations' }
FOSyntax class >> unescapeString: aString [
	"Resolve backslash escapes and entity references, as required for info
	 strings, link destinations and link titles."
	((aString includes: $\) or: [ aString includes: $& ]) ifFalse: [ ^ aString ].
	^ String streamContents: [ :out |
		| i size |
		i := 1.
		size := aString size.
		[ i <= size ] whileTrue: [
			| char |
			char := aString at: i.
			(char = $\ and: [ i < size and: [ self isEscapable: (aString at: i + 1) ] ])
				ifTrue: [
					out nextPut: (aString at: i + 1).
					i := i + 2 ]
				ifFalse: [
					char = $&
						ifTrue: [
							| entity |
							entity := FOEntities matchAt: i in: aString.
							entity
								ifNil: [ out nextPut: char. i := i + 1 ]
								ifNotNil: [
									out nextPutAll: entity first.
									i := i + entity second ] ]
						ifFalse: [ out nextPut: char. i := i + 1 ] ] ] ]
]
