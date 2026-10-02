"
Turns the raw text of a leaf block into inline nodes.

Emphasis and links cannot be recognised by simple left-to-right matching, so the
parser does what CommonMark prescribes: runs of * and _ go on a delimiter stack
and unresolved [ or ![ go on a bracket stack while the text is scanned once;
emphasis is matched up afterwards, and a link is built when its closing bracket
is found. Everything else - code spans, autolinks, raw HTML, entities, escapes
and line breaks - is recognised directly while scanning.
"
Class {
	#name : #FOInlineParser,
	#superclass : #Object,
	#instVars : [
		'subject',
		'pos',
		'container',
		'delimiters',
		'brackets',
		'document'
	],
	#category : #'Foliage-Markdown'
}

{ #category : #'instance creation' }
FOInlineParser class >> parse: aString [
	"Answer the inline nodes of aString. Convenience entry point; link reference
	 definitions are not available this way."
	| paragraph |
	paragraph := FOParagraph new.
	self new parse: aString into: paragraph.
	^ paragraph children
]

{ #category : #'private - reading' }
FOInlineParser >> absoluteUriAutolinkLengthAt: anIndex [
	"<scheme:rest> where scheme is 2 to 32 characters and rest holds no spaces,
	 control characters, < or >."
	| i char schemeLength |
	(self at: anIndex) = $< ifFalse: [ ^ 0 ].
	i := anIndex + 1.
	char := self at: i.
	(char notNil and: [ char isLetter ]) ifFalse: [ ^ 0 ].
	i := i + 1.
	[ char := self at: i.
	char notNil and: [ char isAlphaNumeric or: [ '+.-' includes: char ] ] ]
		whileTrue: [ i := i + 1 ].
	schemeLength := i - anIndex - 1.
	(schemeLength between: 2 and: 32) ifFalse: [ ^ 0 ].
	(self at: i) = $: ifFalse: [ ^ 0 ].
	i := i + 1.
	[ char := self at: i.
	char notNil and: [ char asInteger > 32 and: [ char ~= $< and: [ char ~= $> ] ] ] ]
		whileTrue: [ i := i + 1 ].
	(self at: i) = $> ifFalse: [ ^ 0 ].
	^ i - anIndex + 1
]

{ #category : #'parsing - links' }
FOInlineParser >> addBracketFor: aNode index: anIndex image: aBoolean [
	brackets ifNotNil: [ :each | each bracketAfter: true ].
	brackets := FOBracket new
		node: aNode;
		previous: brackets;
		previousDelimiter: delimiters;
		index: anIndex;
		image: aBoolean;
		yourself
]

{ #category : #'private - building' }
FOInlineParser >> append: aNode [
	^ container addChild: aNode
]

{ #category : #'private - building' }
FOInlineParser >> appendText: aString [
	^ self append: (FOText new string: aString; yourself)
]

{ #category : #'private - reading' }
FOInlineParser >> at: anIndex [
	^ (anIndex between: 1 and: subject size)
		ifTrue: [ subject at: anIndex ]
		ifFalse: [ nil ]
]

{ #category : #'private - reading' }
FOInlineParser >> atEnd [
	^ pos > subject size
]

{ #category : #'private - links' }
FOInlineParser >> atLineEnd [
	"Only spaces may follow, up to and including the end of the line."
	| i |
	i := pos.
	[ i <= subject size and: [ (subject at: i) = $  ] ] whileTrue: [ i := i + 1 ].
	(i > subject size or: [ (subject at: i) = Character lf ])
		ifFalse: [ ^ false ].
	pos := i <= subject size ifTrue: [ i + 1 ] ifFalse: [ i ].
	^ true
]

{ #category : #'private - reading' }
FOInlineParser >> backtickRunLengthAt: anIndex [
	| i |
	i := anIndex.
	[ i <= subject size and: [ (subject at: i) = $` ] ] whileTrue: [ i := i + 1 ].
	^ i - anIndex
]

{ #category : #'private - links' }
FOInlineParser >> collapseWhitespaceIn: aString [
	| lastWasSpace |
	lastWasSpace := false.
	^ String streamContents: [ :out |
		aString do: [ :each |
			(FOSyntax isUnicodeWhitespace: each)
				ifTrue: [
					lastWasSpace ifFalse: [ out nextPut: $  ].
					lastWasSpace := true ]
				ifFalse: [
					out nextPut: each.
					lastWasSpace := false ] ] ]
]

{ #category : #accessing }
FOInlineParser >> document [
	^ document
]

{ #category : #accessing }
FOInlineParser >> document: aDocument [
	document := aDocument
]

{ #category : #'private - reading' }
FOInlineParser >> domainEndAt: anIndex [
	"One or more dot separated labels of letters, digits and hyphens that neither
	 start nor end with a hyphen."
	| i labelStart char |
	i := anIndex.
	[ true ] whileTrue: [
		labelStart := i.
		[ char := self at: i.
		char notNil and: [ char isAlphaNumeric or: [ char = $- ] ] ] whileTrue: [ i := i + 1 ].
		i = labelStart ifTrue: [ ^ 0 ].
		(self at: labelStart) = $- ifTrue: [ ^ 0 ].
		(self at: i - 1) = $- ifTrue: [ ^ 0 ].
		i - labelStart > 63 ifTrue: [ ^ 0 ].
		(self at: i) = $.
			ifTrue: [ i := i + 1 ]
			ifFalse: [ ^ i ] ]
]

{ #category : #'private - reading' }
FOInlineParser >> emailAutolinkLengthAt: anIndex [
	| i char atIndex |
	(self at: anIndex) = $< ifFalse: [ ^ 0 ].
	i := anIndex + 1.
	[ char := self at: i.
	char notNil and: [ char isAlphaNumeric or: [ '.!#$%&''*+/=?^_`{|}~-' includes: char ] ] ]
		whileTrue: [ i := i + 1 ].
	(self at: i) = $@ ifFalse: [ ^ 0 ].
	atIndex := i.
	atIndex = (anIndex + 1) ifTrue: [ ^ 0 ].
	i := i + 1.
	i := self domainEndAt: i.
	i = 0 ifTrue: [ ^ 0 ].
	(self at: i) = $> ifFalse: [ ^ 0 ].
	^ i - anIndex + 1
]

{ #category : #'private - links' }
FOInlineParser >> finishDestinationFrom: aStart parens: openParens [
	(pos = aStart and: [ self peek ~= $) ]) ifTrue: [ ^ nil ].
	openParens ~= 0 ifTrue: [ ^ nil ].
	^ FOSyntax unescapeString: (subject copyFrom: aStart to: pos - 1)
]

{ #category : #'private - reading' }
FOInlineParser >> isSpecial: aCharacter [
	"The characters that may start an inline construct. A newline counts, so a
	 run of plain text never crosses a line ending."
	^ aCharacter = Character lf or: [ '\`[]!<&*_' includes: aCharacter ]
]

{ #category : #'private - reading' }
FOInlineParser >> lastNonSpaceIndexIn: aString [
	| i |
	i := aString size.
	[ i > 0 and: [ (aString at: i) = $  ] ] whileTrue: [ i := i - 1 ].
	^ i
]

{ #category : #accessing }
FOInlineParser >> linkReferences [
	^ document ifNil: [ Dictionary new ] ifNotNil: [ document linkReferences ]
]

{ #category : #'private - building' }
FOInlineParser >> moveNodesAfter: openerNode upTo: closerNodeOrNil into: aNode [
	| siblings startIndex endIndex |
	siblings := openerNode parent children.
	startIndex := siblings indexOf: openerNode.
	endIndex := closerNodeOrNil
		ifNil: [ siblings size + 1 ]
		ifNotNil: [ siblings indexOf: closerNodeOrNil ].
	((siblings copyFrom: startIndex + 1 to: endIndex - 1) asOrderedCollection)
		do: [ :each | aNode addChild: each ]
]

{ #category : #'link references' }
FOInlineParser >> normalizeReference: aString [
	"Strip the brackets, collapse whitespace and case fold, so that [Foo  bar] and
	 [foo bar] name the same reference. Case folding is approximated by lowercasing
	 and uppercasing; the sharp s gets its own rule because it folds to two
	 letters, which no simple case change produces."
	| inner |
	inner := aString copyFrom: 2 to: aString size - 1.
	inner := self foldSharpSIn: inner.
	^ (self collapseWhitespaceIn: inner) trimBoth asLowercase asUppercase
]

{ #category : #'private - links' }
FOInlineParser >> foldSharpSIn: aString [
	| sharp capitalSharp |
	sharp := Character value: 16rDF.
	capitalSharp := Character value: 16r1E9E.
	((aString includes: sharp) or: [ aString includes: capitalSharp ])
		ifFalse: [ ^ aString ].
	^ String streamContents: [ :out |
		aString do: [ :each |
			(each = sharp or: [ each = capitalSharp ])
				ifTrue: [ out nextPutAll: 'ss' ]
				ifFalse: [ out nextPut: each ] ] ]
]

{ #category : #'private - emphasis' }
FOInlineParser >> openersBottomKeyFor: aDelimiter [
	^ Array with: aDelimiter originalCount \\ 3 with: aDelimiter character
]

{ #category : #parsing }
FOInlineParser >> parse: aString into: aNode [
	subject := aString.
	pos := 1.
	container := aNode.
	delimiters := nil.
	brackets := nil.
	[ self parseInline ] whileTrue.
	self processEmphasisFrom: nil.
	^ aNode children
]

{ #category : #'parsing - html' }
FOInlineParser >> parseAutolink [
	| length inner link |
	length := self absoluteUriAutolinkLengthAt: pos.
	length > 0 ifTrue: [
		inner := subject copyFrom: pos + 1 to: pos + length - 2.
		link := FOLink new url: inner; yourself.
		link addChild: (FOText new string: inner; yourself).
		self append: link.
		pos := pos + length.
		^ true ].
	length := self emailAutolinkLengthAt: pos.
	length > 0 ifTrue: [
		inner := subject copyFrom: pos + 1 to: pos + length - 2.
		link := FOLink new url: 'mailto:' , inner; yourself.
		link addChild: (FOText new string: inner; yourself).
		self append: link.
		pos := pos + length.
		^ true ].
	^ false
]

{ #category : #'parsing - text' }
FOInlineParser >> parseBackslash [
	| next |
	pos := pos + 1.
	next := self peek.
	next = Character lf ifTrue: [
		pos := pos + 1.
		self append: FOHardBreak new.
		^ true ].
	(FOSyntax isEscapable: next)
		ifTrue: [
			self appendText: (String with: next).
			pos := pos + 1 ]
		ifFalse: [ self appendText: '\' ].
	^ true
]

{ #category : #'parsing - text' }
FOInlineParser >> parseBackticks [
	| openLength afterOpen searchPos closeLength contents |
	openLength := self backtickRunLengthAt: pos.
	openLength = 0 ifTrue: [ ^ false ].
	afterOpen := pos + openLength.
	searchPos := afterOpen.
	[ searchPos <= subject size ] whileTrue: [
		(subject at: searchPos) = $`
			ifTrue: [
				closeLength := self backtickRunLengthAt: searchPos.
				closeLength = openLength
					ifTrue: [
						contents := (subject copyFrom: afterOpen to: searchPos - 1)
							collect: [ :each | each = Character lf ifTrue: [ $  ] ifFalse: [ each ] ].
						self append: (FOCodeSpan new code: (self stripCodeSpanPadding: contents); yourself).
						pos := searchPos + closeLength.
						^ true ].
				searchPos := searchPos + closeLength ]
			ifFalse: [ searchPos := searchPos + 1 ] ].
	"No closing run of the same length: the backticks are literal text."
	self appendText: (subject copyFrom: pos to: afterOpen - 1).
	pos := afterOpen.
	^ true
]

{ #category : #'parsing - links' }
FOInlineParser >> parseBang [
	| startPos node |
	startPos := pos.
	pos := pos + 1.
	self peek = $[
		ifTrue: [
			pos := pos + 1.
			node := self appendText: '!['.
			self addBracketFor: node index: startPos + 1 image: true ]
		ifFalse: [ self appendText: '!' ].
	^ true
]

{ #category : #'private - links' }
FOInlineParser >> parseBracketedLinkDestination [
	| i char |
	i := pos + 1.
	[ i <= subject size ] whileTrue: [
		char := subject at: i.
		char = $> ifTrue: [
			| inner |
			inner := subject copyFrom: pos + 1 to: i - 1.
			pos := i + 1.
			^ FOSyntax unescapeString: inner ].
		(char = Character lf or: [ char = $< ]) ifTrue: [ ^ nil ].
		char = $\
			ifTrue: [ i := i + 2 ]
			ifFalse: [ i := i + 1 ] ].
	^ nil
]

{ #category : #'parsing - links' }
FOInlineParser >> parseCloseBracket [
	| startPos opener isImage destination title matched savePos target node cursor attributes |
	pos := pos + 1.
	startPos := pos.
	opener := brackets.
	opener ifNil: [
		self appendText: ']'.
		^ true ].
	opener active ifFalse: [
		self appendText: ']'.
		self removeBracket.
		^ true ].
	isImage := opener image.
	savePos := pos.
	matched := false.
	destination := nil.
	title := nil.
	self peek = $( ifTrue: [
		pos := pos + 1.
		self skipSpacesAndOneNewline.
		destination := self parseLinkDestination.
		destination
			ifNil: [ pos := savePos ]
			ifNotNil: [
				| beforeTitle |
				beforeTitle := pos.
				self skipSpacesAndOneNewline.
				(pos > beforeTitle or: [ FOSyntax isAsciiWhitespace: (self at: pos - 1) ])
					ifTrue: [ title := self parseLinkTitle ].
				self skipSpacesAndOneNewline.
				(isImage and: [ self peek ~= $) ])
					ifTrue: [ attributes := self parseImageAttributes ].
				self peek = $)
					ifTrue: [
						pos := pos + 1.
						matched := true ]
					ifFalse: [
						pos := savePos.
						attributes := nil ] ] ].
	matched ifFalse: [
		| beforeLabel labelLength referenceLabel |
		beforeLabel := pos.
		labelLength := self parseLinkLabel.
		pos := pos + labelLength.
		referenceLabel := nil.
		labelLength > 2
			ifTrue: [ referenceLabel := subject copyFrom: beforeLabel to: beforeLabel + labelLength - 1 ]
			ifFalse: [
				opener bracketAfter ifFalse: [
					referenceLabel := subject copyFrom: opener index to: startPos - 1 ] ].
		labelLength = 0 ifTrue: [ pos := savePos ].
		referenceLabel ifNotNil: [
			target := self linkReferences
				at: (self normalizeReference: referenceLabel)
				ifAbsent: [ nil ].
			target ifNotNil: [
				destination := target first.
				title := target second.
				matched := true ] ] ].
	matched ifFalse: [
		self removeBracket.
		pos := startPos.
		self appendText: ']'.
		^ true ].
	node := isImage
		ifTrue: [ FOImage new src: destination; title: title; yourself ]
		ifFalse: [ FOLink new url: destination; title: title; yourself ].
	attributes ifNotNil: [ node attributes: attributes ].
	self moveNodesAfter: opener node upTo: nil into: node.
	self append: node.
	self processEmphasisFrom: opener previousDelimiter.
	self removeBracket.
	opener node unlink.
	isImage ifFalse: [
		cursor := brackets.
		[ cursor notNil ] whileTrue: [
			cursor image ifFalse: [ cursor active: false ].
			cursor := cursor previous ] ].
	^ true
]

{ #category : #parsing }
FOInlineParser >> parseConstructStartingWith: aCharacter [
	aCharacter = Character lf ifTrue: [ ^ self parseNewline ].
	aCharacter = $\ ifTrue: [ ^ self parseBackslash ].
	aCharacter = $` ifTrue: [ ^ self parseBackticks ].
	(aCharacter = $* or: [ aCharacter = $_ ]) ifTrue: [ ^ self parseDelimiterRun: aCharacter ].
	aCharacter = $[ ifTrue: [ ^ self parseOpenBracket ].
	aCharacter = $! ifTrue: [ ^ self parseBang ].
	aCharacter = $] ifTrue: [ ^ self parseCloseBracket ].
	aCharacter = $< ifTrue: [ ^ self parseAutolink or: [ self parseRawHtml ] ].
	aCharacter = $& ifTrue: [ ^ self parseEntity ].
	^ self parseString
]

{ #category : #'parsing - emphasis' }
FOInlineParser >> parseDelimiterRun: aCharacter [
	| scan count start node |
	scan := self scanDelimitersOf: aCharacter.
	scan ifNil: [ ^ false ].
	count := scan first.
	start := pos.
	pos := pos + count.
	node := self appendText: (subject copyFrom: start to: pos - 1).
	(scan second or: [ scan third ]) ifTrue: [
		delimiters := FODelimiter new
			character: aCharacter;
			count: count;
			originalCount: count;
			node: node;
			previous: delimiters;
			canOpen: scan second;
			canClose: scan third;
			yourself.
		delimiters previous ifNotNil: [ :each | each next: delimiters ] ].
	^ true
]

{ #category : #'parsing - text' }
FOInlineParser >> parseEntity [
	| match |
	match := FOEntities matchAt: pos in: subject.
	match ifNil: [ ^ false ].
	self appendText: match first.
	pos := pos + match second.
	^ true
]

{ #category : #'parsing - links' }
FOInlineParser >> parseImageAttributes [
	"Foliage lets an author add HTML attributes after an image destination, as in
	 ![alt](/images/x.svg class=u-max-full-width). CommonMark would stop reading
	 the link there, so the pairs are consumed here instead."
	| close text result |
	close := subject indexOf: $) startingAt: pos.
	close = 0 ifTrue: [ ^ nil ].
	text := subject copyFrom: pos to: close - 1.
	(text includes: Character lf) ifTrue: [ ^ nil ].
	result := Dictionary new.
	text substrings do: [ :pair |
		| equals |
		equals := pair indexOf: $=.
		(equals between: 2 and: pair size - 1) ifFalse: [ ^ nil ].
		result at: (pair first: equals - 1) asSymbol put: (pair allButFirst: equals) ].
	result ifEmpty: [ ^ nil ].
	pos := close.
	^ result
]

{ #category : #parsing }
FOInlineParser >> parseInline [
	| char handled |
	self atEnd ifTrue: [ ^ false ].
	char := self peek.
	handled := self parseConstructStartingWith: char.
	handled ifFalse: [
		pos := pos + 1.
		self appendText: (String with: char) ].
	^ true
]

{ #category : #'parsing - links' }
FOInlineParser >> parseLinkDestination [
	| start openParens char |
	self peek = $< ifTrue: [ ^ self parseBracketedLinkDestination ].
	start := pos.
	openParens := 0.
	[ char := self peek.
	char notNil ] whileTrue: [
		(char = $\ and: [ FOSyntax isEscapable: (self at: pos + 1) ])
			ifTrue: [ pos := pos + 2 ]
			ifFalse: [
				char = $(
					ifTrue: [
						pos := pos + 1.
						openParens := openParens + 1 ]
					ifFalse: [
						char = $)
							ifTrue: [
								openParens < 1 ifTrue: [ ^ self finishDestinationFrom: start parens: openParens ].
								pos := pos + 1.
								openParens := openParens - 1 ]
							ifFalse: [
								(FOSyntax isAsciiSpaceOrControl: char)
									ifTrue: [ ^ self finishDestinationFrom: start parens: openParens ]
									ifFalse: [ pos := pos + 1 ] ] ] ] ].
	^ self finishDestinationFrom: start parens: openParens
]

{ #category : #'parsing - links' }
FOInlineParser >> parseLinkLabel [
	"Answer the length of a [...] label at the current position and move past it,
	 or answer 0 and stay where we are."
	| i char count |
	self peek = $[ ifFalse: [ ^ 0 ].
	i := pos + 1.
	count := 0.
	[ i <= subject size ] whileTrue: [
		char := subject at: i.
		char = $] ifTrue: [
			count > 1000 ifTrue: [ ^ 0 ].
			^ i - pos + 1 ].
		char = $[ ifTrue: [ ^ 0 ].
		char = $\
			ifTrue: [ i := i + 2 ]
			ifFalse: [ i := i + 1 ].
		count := count + 1 ].
	^ 0
]

{ #category : #'link references' }
FOInlineParser >> parseLinkReferenceIn: aString [
	"Read a link reference definition at the start of aString, register it with
	 the document and answer how many characters it took. Answers 0 when there is
	 none."
	| labelLength rawLabel destination title beforeTitle normalized |
	subject := aString.
	pos := 1.
	labelLength := self parseLinkLabel.
	labelLength = 0 ifTrue: [ ^ 0 ].
	rawLabel := subject copyFrom: 1 to: labelLength.
	pos := pos + labelLength.
	self peek = $: ifFalse: [ ^ 0 ].
	pos := pos + 1.
	self skipSpacesAndOneNewline.
	destination := self parseLinkDestination.
	"An empty destination written as <> is legal."
	destination ifNil: [ ^ 0 ].
	beforeTitle := pos.
	self skipSpacesAndOneNewline.
	title := pos > beforeTitle ifTrue: [ self parseLinkTitle ] ifFalse: [ nil ].
	title ifNil: [ pos := beforeTitle ].
	self atLineEnd ifFalse: [
		title ifNil: [ ^ 0 ].
		title := nil.
		pos := beforeTitle.
		self atLineEnd ifFalse: [ ^ 0 ] ].
	normalized := self normalizeReference: rawLabel.
	normalized isEmpty ifTrue: [ ^ 0 ].
	self linkReferences
		at: normalized
		ifAbsentPut: [ Array with: destination with: title ].
	^ pos - 1
]

{ #category : #'parsing - links' }
FOInlineParser >> parseLinkTitle [
	| opening closing i char |
	opening := self peek.
	opening ifNil: [ ^ nil ].
	closing := nil.
	opening = $" ifTrue: [ closing := $" ].
	opening = $' ifTrue: [ closing := $' ].
	opening = $( ifTrue: [ closing := $) ].
	closing ifNil: [ ^ nil ].
	i := pos + 1.
	[ i <= subject size ] whileTrue: [
		char := subject at: i.
		char = closing ifTrue: [
			| inner |
			inner := subject copyFrom: pos + 1 to: i - 1.
			pos := i + 1.
			^ FOSyntax unescapeString: inner ].
		(opening = $( and: [ char = $( ]) ifTrue: [ ^ nil ].
		char = $\
			ifTrue: [ i := i + 2 ]
			ifFalse: [ i := i + 1 ] ].
	^ nil
]

{ #category : #'parsing - text' }
FOInlineParser >> parseNewline [
	| last literal trimmed |
	pos := pos + 1.
	last := container lastChild.
	(last notNil and: [ last isText and: [ last string endsWith: ' ' ] ])
		ifTrue: [
			literal := last string.
			trimmed := literal copyFrom: 1 to: (self lastNonSpaceIndexIn: literal).
			last string: trimmed.
			(literal size - trimmed size) >= 2
				ifTrue: [ self append: FOHardBreak new ]
				ifFalse: [ self append: FOSoftBreak new ] ]
		ifFalse: [ self append: FOSoftBreak new ].
	"Leading spaces on the next line are not content."
	[ self peek = $  ] whileTrue: [ pos := pos + 1 ].
	^ true
]

{ #category : #'parsing - links' }
FOInlineParser >> parseOpenBracket [
	| startPos node |
	startPos := pos.
	pos := pos + 1.
	node := self appendText: '['.
	self addBracketFor: node index: startPos image: false.
	^ true
]

{ #category : #'parsing - html' }
FOInlineParser >> parseRawHtml [
	| length |
	length := FOHtmlTagScanner anyTagLengthIn: subject from: pos.
	length = 0 ifTrue: [ ^ false ].
	self append: (FORawHTMLInline new html: (subject copyFrom: pos to: pos + length - 1); yourself).
	pos := pos + length.
	^ true
]

{ #category : #'parsing - text' }
FOInlineParser >> parseString [
	| start |
	start := pos.
	[ self atEnd not and: [ (self isSpecial: self peek) not ] ] whileTrue: [ pos := pos + 1 ].
	pos = start ifTrue: [ ^ false ].
	self appendText: (subject copyFrom: start to: pos - 1).
	^ true
]

{ #category : #'private - reading' }
FOInlineParser >> peek [
	^ self at: pos
]

{ #category : #'parsing - emphasis' }
FOInlineParser >> processEmphasisFrom: stackBottom [
	| closer opener openersBottom openerFound oldCloser useDelims openerNode closerNode emphasis temp oddMatch |
	openersBottom := Dictionary new.
	#(0 1 2) do: [ :modulo |
		#($* $_) do: [ :each |
			openersBottom at: (Array with: modulo with: each) put: stackBottom ] ].
	closer := delimiters.
	[ closer notNil and: [ closer previous ~~ stackBottom ] ] whileTrue: [ closer := closer previous ].
	[ closer notNil ] whileTrue: [
		closer canClose
			ifFalse: [ closer := closer next ]
			ifTrue: [
				opener := closer previous.
				openerFound := false.
				[ openerFound not
					and: [ opener notNil
					and: [ opener ~~ stackBottom
					and: [ opener ~~ (openersBottom at: (self openersBottomKeyFor: closer)) ] ] ] ]
					whileTrue: [
						"The rule of three: runs that could be both opener and closer only
						 match when their lengths are not a multiple of three."
						oddMatch := (closer canOpen or: [ opener canClose ])
							and: [ closer originalCount \\ 3 ~= 0
							and: [ (opener originalCount + closer originalCount) \\ 3 = 0 ] ].
						(opener character = closer character
							and: [ opener canOpen and: [ oddMatch not ] ])
							ifTrue: [ openerFound := true ]
							ifFalse: [ opener := opener previous ] ].
				oldCloser := closer.
				openerFound
					ifTrue: [
						useDelims := (closer count >= 2 and: [ opener count >= 2 ])
							ifTrue: [ 2 ] ifFalse: [ 1 ].
						openerNode := opener node.
						closerNode := closer node.
						opener count: opener count - useDelims.
						closer count: closer count - useDelims.
						openerNode string: (openerNode string allButLast: useDelims).
						closerNode string: (closerNode string allButLast: useDelims).
						emphasis := useDelims = 1 ifTrue: [ FOItalic new ] ifFalse: [ FOBold new ].
						self moveNodesAfter: openerNode upTo: closerNode into: emphasis.
						openerNode parent addChild: emphasis after: openerNode.
						self removeDelimitersBetween: opener and: closer.
						opener count = 0 ifTrue: [
							openerNode unlink.
							self removeDelimiter: opener ].
						closer count = 0 ifTrue: [
							closerNode unlink.
							temp := closer next.
							self removeDelimiter: closer.
							closer := temp ] ]
					ifFalse: [
						closer := closer next.
						openersBottom
							at: (self openersBottomKeyFor: oldCloser)
							put: oldCloser previous.
						oldCloser canOpen ifFalse: [ self removeDelimiter: oldCloser ] ] ] ].
	[ delimiters notNil and: [ delimiters ~~ stackBottom ] ]
		whileTrue: [ self removeDelimiter: delimiters ]
]

{ #category : #'parsing - links' }
FOInlineParser >> removeBracket [
	brackets := brackets previous
]

{ #category : #'private - emphasis' }
FOInlineParser >> removeDelimiter: aDelimiter [
	aDelimiter previous ifNotNil: [ :each | each next: aDelimiter next ].
	aDelimiter next
		ifNil: [ delimiters := aDelimiter previous ]
		ifNotNil: [ :each | each previous: aDelimiter previous ]
]

{ #category : #'private - emphasis' }
FOInlineParser >> removeDelimitersBetween: anOpener and: aCloser [
	anOpener next == aCloser ifTrue: [ ^ self ].
	anOpener next: aCloser.
	aCloser previous: anOpener
]

{ #category : #'parsing - emphasis' }
FOInlineParser >> scanDelimitersOf: aCharacter [
	"Answer an Array with the length of the run and whether it can open and close
	 emphasis, or nil. A run is left flanking when it is not followed by
	 whitespace and either not followed by punctuation or preceded by whitespace
	 or punctuation; right flanking is the mirror image."
	| count start charBefore charAfter afterIsWhitespace afterIsPunctuation beforeIsWhitespace beforeIsPunctuation leftFlanking rightFlanking |
	start := pos.
	count := 0.
	[ self peek = aCharacter ] whileTrue: [
		count := count + 1.
		pos := pos + 1 ].
	count = 0 ifTrue: [ ^ nil ].
	charBefore := start = 1 ifTrue: [ Character lf ] ifFalse: [ subject at: start - 1 ].
	charAfter := self peek ifNil: [ Character lf ].
	pos := start.
	afterIsWhitespace := FOSyntax isUnicodeWhitespace: charAfter.
	afterIsPunctuation := FOSyntax isPunctuation: charAfter.
	beforeIsWhitespace := FOSyntax isUnicodeWhitespace: charBefore.
	beforeIsPunctuation := FOSyntax isPunctuation: charBefore.
	leftFlanking := afterIsWhitespace not
		and: [ afterIsPunctuation not or: [ beforeIsWhitespace or: [ beforeIsPunctuation ] ] ].
	rightFlanking := beforeIsWhitespace not
		and: [ beforeIsPunctuation not or: [ afterIsWhitespace or: [ afterIsPunctuation ] ] ].
	aCharacter = $_ ifTrue: [
		^ Array
			with: count
			with: (leftFlanking and: [ rightFlanking not or: [ beforeIsPunctuation ] ])
			with: (rightFlanking and: [ leftFlanking not or: [ afterIsPunctuation ] ]) ].
	^ Array with: count with: leftFlanking with: rightFlanking
]

{ #category : #'parsing - links' }
FOInlineParser >> skipSpacesAndOneNewline [
	[ self peek = $  ] whileTrue: [ pos := pos + 1 ].
	self peek = Character lf ifTrue: [
		pos := pos + 1.
		[ self peek = $  ] whileTrue: [ pos := pos + 1 ] ].
	^ true
]

{ #category : #'private - reading' }
FOInlineParser >> stripCodeSpanPadding: aString [
	"One space on both sides is stripped, unless the content is all spaces."
	(aString size >= 2
		and: [ aString first = $ 
		and: [ aString last = $ 
		and: [ aString anySatisfy: [ :each | each ~= $  ] ] ] ])
		ifTrue: [ ^ aString copyFrom: 2 to: aString size - 1 ].
	^ aString
]
