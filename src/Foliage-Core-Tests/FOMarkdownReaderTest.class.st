Class {
	#name : #FOMarkdownReaderTest,
	#superclass : #TestCase,
	#category : #'Foliage-Core-Tests'
}

{ #category : #private }
FOMarkdownReaderTest >> realPostPath [
	^ '/Users/norbert/projects/noha.github.io/raw/blog/2022-12-03_picking-it-up.md' asFileReference
]

{ #category : #tests }
FOMarkdownReaderTest >> testReadsFrontmatterAndBodyFromRealPost [
	| page |
	page := (FOMarkdownReader file: self realPostPath) model.
	self assert: (page isKindOf: FOFoliagePage).
	self assert: page title equals: 'Picking it up'.
	self assert: page layout equals: 'blog-post'.
	self assert: page publishDate equals: (Date year: 2022 month: 12 day: 3)
]

{ #category : #tests }
FOMarkdownReaderTest >> testRenderOnProducesExpectedHtmlFromRealPost [
	| page stream html |
	page := (FOMarkdownReader file: self realPostPath) model.
	stream := WriteStream on: String new.
	page renderOn: stream.
	html := stream contents.
	self assert: (html includesSubstring: '<h1>Picking it up</h1>').
	self assert: (html includesSubstring: '<p>What happened so far?')
]

{ #category : #tests }
FOMarkdownReaderTest >> testSourcePathIsSet [
	| page |
	page := (FOMarkdownReader file: self realPostPath) model.
	self assert: page sourcePath asString equals: self realPostPath asPath asString
]
