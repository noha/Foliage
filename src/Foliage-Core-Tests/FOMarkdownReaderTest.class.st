Class {
	#name : #FOMarkdownReaderTest,
	#superclass : #TestCase,
	#category : #'Foliage-Core-Tests'
}

{ #category : #private }
FOMarkdownReaderTest >> nl [
	^ String with: Character lf
]

{ #category : #private }
FOMarkdownReaderTest >> realPostContent [
	"An inlined copy of noha.github.io/raw/blog/2022-12-03_picking-it-up.md -
	inlined (not read from the sibling checkout's absolute path) so this test
	is self-contained and portable across machines/CI, same reasoning as the
	syntax.md integration test in Foliage-Markdown-Tests."
	^ 'title: Picking it up', self nl,
		'layout: blog-post', self nl,
		'publishDate: 2022-12-03', self nl,
		self nl,
		'# Picking it up', self nl,
		self nl,
		'What happened so far? I did the usual thing. I created a blog and wrote a blog engine for it. The only content in the blog was about creating the blog engine itself. And as usual after the first release nothing happened anymore...', self nl,
		self nl,
		'This time it is different because it wasn''t the end of the project and the blog. Foliage got a new user which made me quite proud. After several years of instable web service of the [Pharo website](http://pharo.org) the site was changed to be produced by Foliage. It now runs stable and super fast thanks to static site content.', self nl,
		self nl,
		'Almost 2 years after my last post I try to pick up where I left off. The same promise to write more of the things I do and that I tell people all the time. The last 2 years have also been very busy ramping up our new service [ApptiveGrid](https://www.apptivegrid.de/). So there is plenty of things to write about. '
]

{ #category : #private }
FOMarkdownReaderTest >> writeRealPostTo: aFileReference [
	aFileReference writeStreamDo: [ :s | s nextPutAll: self realPostContent ].
	^ aFileReference
]

{ #category : #private }
FOMarkdownReaderTest >> withRealPostFileDo: aBlock [
	| tempFile |
	tempFile := FileLocator temp / ('fo-markdown-reader-test-', UUID new asString36, '.md').
	self writeRealPostTo: tempFile.
	[ aBlock value: tempFile ] ensure: [ tempFile ensureDelete ]
]

{ #category : #tests }
FOMarkdownReaderTest >> testReadsFrontmatterAndBodyFromRealPost [
	self withRealPostFileDo: [ :file |
		| page |
		page := (FOMarkdownReader file: file) model.
		self assert: (page isKindOf: FOFoliagePage).
		self assert: page title equals: 'Picking it up'.
		self assert: page layout equals: 'blog-post'.
		self assert: page publishDate equals: (Date year: 2022 month: 12 day: 3) ]
]

{ #category : #tests }
FOMarkdownReaderTest >> testRenderOnProducesExpectedHtmlFromRealPost [
	self withRealPostFileDo: [ :file |
		| page stream html |
		page := (FOMarkdownReader file: file) model.
		stream := WriteStream on: String new.
		page renderOn: stream.
		html := stream contents.
		self assert: (html includesSubstring: '<h1>Picking it up</h1>').
		self assert: (html includesSubstring: '<p>What happened so far?') ]
]

{ #category : #tests }
FOMarkdownReaderTest >> testSourcePathIsSet [
	self withRealPostFileDo: [ :file |
		| page |
		page := (FOMarkdownReader file: file) model.
		self assert: page sourcePath asString equals: file asPath asString ]
]
