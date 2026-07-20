Class {
	#name : #FOFrontmatterParserTest,
	#superclass : #TestCase,
	#category : #'Foliage-Frontmatter-Tests'
}

{ #category : #private }
FOFrontmatterParserTest >> nl [
	^ String with: Character lf
]

{ #category : #tests }
FOFrontmatterParserTest >> testQuotedValueStripsQuotes [
	| result |
	result := FOFrontmatterParser parse: 'publishDate: "2020-09-15"', self nl, self nl, 'body text'.
	self assert: (result at: #publishDate) equals: '2020-09-15'
]

{ #category : #tests }
FOFrontmatterParserTest >> testBareValueIsKeptAsIs [
	| result |
	result := FOFrontmatterParser parse: 'publishDate: 2020-10-06', self nl, self nl, 'body text'.
	self assert: (result at: #publishDate) equals: '2020-10-06'
]

{ #category : #tests }
FOFrontmatterParserTest >> testColonInValueIsPreserved [
	| result |
	result := FOFrontmatterParser parse: 'homepage: http://example.com', self nl, self nl, 'body text'.
	self assert: (result at: #homepage) equals: 'http://example.com'
]

{ #category : #tests }
FOFrontmatterParserTest >> testArbitraryKeysAreGeneric [
	| result expectedBody |
	expectedBody := '# Picking it up', self nl, 'some text'.
	result := FOFrontmatterParser parse:
		'title: Picking it up', self nl,
		'layout: blog-post', self nl,
		'publishDate: 2022-12-03', self nl,
		self nl,
		expectedBody.
	self assert: (result at: #title) equals: 'Picking it up'.
	self assert: (result at: #layout) equals: 'blog-post'.
	self assert: (result at: #publishDate) equals: '2022-12-03'.
	self assert: result properties size equals: 3.
	self assert: result body equals: expectedBody
]

{ #category : #tests }
FOFrontmatterParserTest >> testMissingBlankLineMeansEmptyBody [
	| result |
	result := FOFrontmatterParser parse: 'title: Foo', self nl, 'layout: page'.
	self assert: (result at: #title) equals: 'Foo'.
	self assert: (result at: #layout) equals: 'page'.
	self assert: result body equals: ''
]

{ #category : #tests }
FOFrontmatterParserTest >> testNoFrontmatterMeansWholeFileIsBody [
	| result original |
	original := '# A syntax example for testing', self nl, self nl, 'Some text here.'.
	result := FOFrontmatterParser parse: original.
	self assert: result properties isEmpty.
	self assert: result body equals: original
]

{ #category : #tests }
FOFrontmatterParserTest >> testProseWithColonIsNotMistakenForFrontmatter [
	| result original |
	original := 'This is unusual: right from the start.', self nl, self nl, 'More text.'.
	result := FOFrontmatterParser parse: original.
	self assert: result properties isEmpty.
	self assert: result body equals: original
]
