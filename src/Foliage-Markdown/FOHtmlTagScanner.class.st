"
Recognises the pieces of HTML syntax that CommonMark embeds in markdown: open
and closing tags, comments, processing instructions, declarations and CDATA
sections. The same grammar decides whether a line starts an HTML block and
whether a < inside a paragraph is raw HTML or literal text.

All methods answer the length of the construct starting at a given (one based)
index, or 0 when it does not match, so callers can advance by the answer.
"
Class {
	#name : #FOHtmlTagScanner,
	#superclass : #Object,
	#category : #'Foliage-Markdown'
}

{ #category : #accessing }
FOHtmlTagScanner class >> blockTagNames [
	^ #( 'address' 'article' 'aside' 'base' 'basefont' 'blockquote' 'body'
	'caption' 'center' 'col' 'colgroup' 'dd' 'details' 'dialog' 'dir' 'div' 'dl'
	'dt' 'fieldset' 'figcaption' 'figure' 'footer' 'form' 'frame' 'frameset'
	'h1' 'h2' 'h3' 'h4' 'h5' 'h6' 'head' 'header' 'hr' 'html' 'iframe' 'legend'
	'li' 'link' 'main' 'menu' 'menuitem' 'nav' 'noframes' 'ol' 'optgroup'
	'option' 'p' 'param' 'section' 'source' 'summary' 'table' 'tbody' 'td'
	'tfoot' 'th' 'thead' 'title' 'tr' 'track' 'ul' )
]

{ #category : #accessing }
FOHtmlTagScanner class >> literalTagNames [
	"The tags whose content is taken verbatim up to the matching closing tag."
	^ #( 'script' 'pre' 'textarea' 'style' )
]

{ #category : #'private - characters' }
FOHtmlTagScanner class >> isWhitespaceAt: anIndex in: aString [
	| char |
	(anIndex between: 1 and: aString size) ifFalse: [ ^ false ].
	char := aString at: anIndex.
	^ char = $  or: [ char = Character tab or: [ char = Character lf or: [ char = Character cr ] ] ]
]

{ #category : #'private - characters' }
FOHtmlTagScanner class >> skipWhitespaceFrom: anIndex in: aString [
	| i |
	i := anIndex.
	[ self isWhitespaceAt: i in: aString ] whileTrue: [ i := i + 1 ].
	^ i
]

{ #category : #'private - characters' }
FOHtmlTagScanner class >> at: anIndex in: aString [
	^ (anIndex between: 1 and: aString size)
		ifTrue: [ aString at: anIndex ]
		ifFalse: [ nil ]
]

{ #category : #scanning }
FOHtmlTagScanner class >> tagNameEndIn: aString from: anIndex [
	"Answer the index after a tag name starting at anIndex, or 0."
	| i char |
	char := self at: anIndex in: aString.
	(char notNil and: [ char isLetter ]) ifFalse: [ ^ 0 ].
	i := anIndex + 1.
	[ char := self at: i in: aString.
	char notNil and: [ char isAlphaNumeric or: [ char = $- ] ] ] whileTrue: [ i := i + 1 ].
	^ i
]

{ #category : #scanning }
FOHtmlTagScanner class >> openTagLengthIn: aString from: anIndex [
	| i nameEnd |
	(self at: anIndex in: aString) = $< ifFalse: [ ^ 0 ].
	nameEnd := self tagNameEndIn: aString from: anIndex + 1.
	nameEnd = 0 ifTrue: [ ^ 0 ].
	i := nameEnd.
	[ | attributeEnd |
	attributeEnd := self attributeEndIn: aString from: i.
	attributeEnd = i ifTrue: [ false ] ifFalse: [ i := attributeEnd. true ] ] whileTrue.
	i := self skipWhitespaceFrom: i in: aString.
	(self at: i in: aString) = $/ ifTrue: [ i := i + 1 ].
	(self at: i in: aString) = $> ifFalse: [ ^ 0 ].
	^ i - anIndex + 1
]

{ #category : #scanning }
FOHtmlTagScanner class >> attributeEndIn: aString from: anIndex [
	"An attribute is whitespace, a name and an optional value. Answer the index
	 after it, or anIndex when there is none."
	| i nameStart char |
	i := self skipWhitespaceFrom: anIndex in: aString.
	i = anIndex ifTrue: [ ^ anIndex ].
	nameStart := i.
	char := self at: i in: aString.
	(char notNil and: [ char isLetter or: [ char = $_ or: [ char = $: ] ] ])
		ifFalse: [ ^ anIndex ].
	i := i + 1.
	[ char := self at: i in: aString.
	char notNil and: [ char isAlphaNumeric or: [ '_.:-' includes: char ] ] ]
		whileTrue: [ i := i + 1 ].
	nameStart = i ifTrue: [ ^ anIndex ].
	^ self attributeValueEndIn: aString from: i
]

{ #category : #scanning }
FOHtmlTagScanner class >> attributeValueEndIn: aString from: anIndex [
	| i char valueEnd |
	i := self skipWhitespaceFrom: anIndex in: aString.
	(self at: i in: aString) = $= ifFalse: [ ^ anIndex ].
	i := self skipWhitespaceFrom: i + 1 in: aString.
	char := self at: i in: aString.
	char ifNil: [ ^ anIndex ].
	(char = $" or: [ char = $' ])
		ifTrue: [
			valueEnd := aString indexOf: char startingAt: i + 1.
			valueEnd = 0 ifTrue: [ ^ anIndex ].
			^ valueEnd + 1 ].
	valueEnd := i.
	[ char := self at: valueEnd in: aString.
	char notNil
		and: [ ((self isWhitespaceAt: valueEnd in: aString) or: [ '"''=<>`' includes: char ]) not ] ]
		whileTrue: [ valueEnd := valueEnd + 1 ].
	valueEnd = i ifTrue: [ ^ anIndex ].
	^ valueEnd
]

{ #category : #scanning }
FOHtmlTagScanner class >> closeTagLengthIn: aString from: anIndex [
	| i nameEnd |
	(self at: anIndex in: aString) = $< ifFalse: [ ^ 0 ].
	(self at: anIndex + 1 in: aString) = $/ ifFalse: [ ^ 0 ].
	nameEnd := self tagNameEndIn: aString from: anIndex + 2.
	nameEnd = 0 ifTrue: [ ^ 0 ].
	i := self skipWhitespaceFrom: nameEnd in: aString.
	(self at: i in: aString) = $> ifFalse: [ ^ 0 ].
	^ i - anIndex + 1
]

{ #category : #scanning }
FOHtmlTagScanner class >> commentLengthIn: aString from: anIndex [
	"<!-->, <!---> or <!-- followed by text without --> and a closing -->."
	| end |
	(self at: anIndex in: aString) = $< ifFalse: [ ^ 0 ].
	(aString copyFrom: anIndex to: (anIndex + 4 min: aString size)) = '<!-->'
		ifTrue: [ ^ 5 ].
	(aString copyFrom: anIndex to: (anIndex + 5 min: aString size)) = '<!--->'
		ifTrue: [ ^ 6 ].
	(aString copyFrom: anIndex to: (anIndex + 3 min: aString size)) = '<!--'
		ifFalse: [ ^ 0 ].
	end := aString indexOfSubCollection: '-->' startingAt: anIndex + 4.
	end = 0 ifTrue: [ ^ 0 ].
	^ end + 3 - anIndex
]

{ #category : #scanning }
FOHtmlTagScanner class >> processingInstructionLengthIn: aString from: anIndex [
	| end |
	(aString copyFrom: anIndex to: (anIndex + 1 min: aString size)) = '<?' ifFalse: [ ^ 0 ].
	end := aString indexOfSubCollection: '?>' startingAt: anIndex + 2.
	end = 0 ifTrue: [ ^ 0 ].
	^ end + 2 - anIndex
]

{ #category : #scanning }
FOHtmlTagScanner class >> declarationLengthIn: aString from: anIndex [
	"<! an ASCII letter, anything but > and a closing >."
	| end char |
	(self at: anIndex in: aString) = $< ifFalse: [ ^ 0 ].
	(self at: anIndex + 1 in: aString) = $! ifFalse: [ ^ 0 ].
	char := self at: anIndex + 2 in: aString.
	(char notNil and: [ char isLetter and: [ char asInteger < 128 ] ]) ifFalse: [ ^ 0 ].
	end := aString indexOf: $> startingAt: anIndex + 3.
	end = 0 ifTrue: [ ^ 0 ].
	^ end + 1 - anIndex
]

{ #category : #scanning }
FOHtmlTagScanner class >> cdataLengthIn: aString from: anIndex [
	| end |
	(aString copyFrom: anIndex to: (anIndex + 8 min: aString size)) = '<![CDATA[' ifFalse: [ ^ 0 ].
	end := aString indexOfSubCollection: ']]>' startingAt: anIndex + 9.
	end = 0 ifTrue: [ ^ 0 ].
	^ end + 3 - anIndex
]

{ #category : #scanning }
FOHtmlTagScanner class >> anyTagLengthIn: aString from: anIndex [
	"Any of the constructs, tried in the order the spec lists them."
	| length |
	length := self openTagLengthIn: aString from: anIndex.
	length > 0 ifTrue: [ ^ length ].
	length := self closeTagLengthIn: aString from: anIndex.
	length > 0 ifTrue: [ ^ length ].
	length := self commentLengthIn: aString from: anIndex.
	length > 0 ifTrue: [ ^ length ].
	length := self processingInstructionLengthIn: aString from: anIndex.
	length > 0 ifTrue: [ ^ length ].
	length := self declarationLengthIn: aString from: anIndex.
	length > 0 ifTrue: [ ^ length ].
	^ self cdataLengthIn: aString from: anIndex
]

{ #category : #'html blocks' }
FOHtmlTagScanner class >> htmlBlockTypeIn: aString canInterruptParagraph: aBoolean [
	"Answer which of the seven kinds of HTML block aString starts, or 0. Only the
	 seventh kind is barred from interrupting a paragraph."
	(aString beginsWith: '<') ifFalse: [ ^ 0 ].
	(self startsLiteralTagIn: aString) ifTrue: [ ^ 1 ].
	(aString beginsWith: '<!--') ifTrue: [ ^ 2 ].
	(aString beginsWith: '<?') ifTrue: [ ^ 3 ].
	((aString beginsWith: '<!') and: [ (self at: 3 in: aString) notNil
		and: [ (self at: 3 in: aString) isLetter ] ]) ifTrue: [ ^ 4 ].
	(aString beginsWith: '<![CDATA[') ifTrue: [ ^ 5 ].
	(self startsBlockTagIn: aString) ifTrue: [ ^ 6 ].
	(aBoolean and: [ self isCompleteTagLine: aString ]) ifTrue: [ ^ 7 ].
	^ 0
]

{ #category : #'html blocks' }
FOHtmlTagScanner class >> startsLiteralTagIn: aString [
	^ self literalTagNames anySatisfy: [ :name |
		| after |
		((aString size >= (name size + 1))
			and: [ ((aString copyFrom: 2 to: name size + 1) asLowercase = name) ])
			and: [ after := self at: name size + 2 in: aString.
				after isNil
					or: [ after = $> or: [ self isWhitespaceAt: name size + 2 in: aString ] ] ] ]
]

{ #category : #'html blocks' }
FOHtmlTagScanner class >> startsBlockTagIn: aString [
	| start |
	start := (self at: 2 in: aString) = $/ ifTrue: [ 3 ] ifFalse: [ 2 ].
	^ self blockTagNames anySatisfy: [ :name |
		| after end |
		end := start + name size - 1.
		(aString size >= end
			and: [ (aString copyFrom: start to: end) asLowercase = name ])
			and: [ after := self at: end + 1 in: aString.
				after isNil
					or: [ after = $>
					or: [ (self isWhitespaceAt: end + 1 in: aString)
					or: [ after = $/ and: [ (self at: end + 2 in: aString) = $> ] ] ] ] ] ]
]

{ #category : #'html blocks' }
FOHtmlTagScanner class >> isCompleteTagLine: aString [
	"A complete open or closing tag with nothing but whitespace after it."
	| length rest |
	length := self openTagLengthIn: aString from: 1.
	length = 0 ifTrue: [ length := self closeTagLengthIn: aString from: 1 ].
	length = 0 ifTrue: [ ^ false ].
	rest := aString allButFirst: length.
	^ FOSyntax isBlank: rest
]

{ #category : #'html blocks' }
FOHtmlTagScanner class >> line: aString closesHtmlBlockType: anInteger [
	anInteger = 1 ifTrue: [
		^ self literalTagNames anySatisfy: [ :name |
			aString asLowercase includesSubstring: '</' , name , '>' ] ].
	anInteger = 2 ifTrue: [ ^ aString includesSubstring: '-->' ].
	anInteger = 3 ifTrue: [ ^ aString includesSubstring: '?>' ].
	anInteger = 4 ifTrue: [ ^ aString includes: $> ].
	anInteger = 5 ifTrue: [ ^ aString includesSubstring: ']]>' ].
	^ false
]
