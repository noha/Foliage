Class {
	#name : #FOSeries,
	#superclass : #Object,
	#instVars : [
		'slug',
		'posts',
		'blog'
	],
	#category : #'Foliage-Core-Blog'
}

{ #category : #'instance creation' }
FOSeries class >> titleFromSlug: aSlug [
	"'soil' -> 'Soil', 'byob-database' -> 'Byob Database'. A zero-config
	stand-in for a real display title, per the lean-rollout decision to defer
	a slug->title registry until one is actually needed."
	^ String streamContents: [ :s |
		(aSlug substrings: '-') do: [ :word |
			s nextPutAll: word first asUppercase asString.
			word size > 1 ifTrue: [ s nextPutAll: (word copyFrom: 2 to: word size) ] ]
		separatedBy: [ s nextPut: $  ] ]
]

{ #category : #accessing }
FOSeries >> abstract [
	"A hand-written data/series/<slug>.md overrides the auto-derived
	abstract, if present - read directly from disk (frontmatter + body,
	same parsers as any other content file) rather than through the normal
	FOImporter/site-tree mechanism, since this file must never become a
	published page of its own (it would collide with the auto-generated
	overview page at the same slug). Falls back to the first (oldest, i.e.
	reading-order-first) post's own already-truncated abstract when no such
	file exists - same zero-config reasoning as titleFromSlug:."
	| dataFile |
	dataFile := self dataAbstractFile.
	^ dataFile exists
		ifTrue: [ self renderSeriesDataFile: dataFile ]
		ifFalse: [ self posts first abstract ]
]

{ #category : #accessing }
FOSeries >> dataAbstractFile [
	^ (self website dataPath / 'series' / (slug, '.md')) asFileReference
]

{ #category : #testing }
FOSeries >> hasCustomAbstract [
	^ self dataAbstractFile exists
]

{ #category : #accessing }
FOSeries >> renderSeriesDataFile: aFileReference [
	"Renders a hand-written data/series/<slug>[-teaser].md file to real HTML
	(not just flattened plain text) - both the series abstract and the post
	teaser are meant to be shown as formatted content, e.g. with inline
	links to specific earlier posts. Used by both #abstract and #teaser."
	| frontmatter |
	frontmatter := FOFrontmatterParser parse: aFileReference contents.
	^ FOHTMLRenderVisitor render: (FOMarkdownParser parse: frontmatter body)
]

{ #category : #accessing }
FOSeries >> dataTeaserFile [
	^ (self website dataPath / 'series' / (slug, '-teaser.md')) asFileReference
]

{ #category : #testing }
FOSeries >> hasCustomTeaser [
	^ self dataTeaserFile exists
]

{ #category : #accessing }
FOSeries >> teaser [
	"The short blurb shown in the highlighted box on every post belonging to
	this series. Falls back to #abstract itself (not to the first post's
	abstract) when no dedicated teaser file exists, so a series doesn't need
	a second file unless the author actually wants a different short text."
	| dataFile |
	dataFile := self dataTeaserFile.
	^ dataFile exists
		ifTrue: [ self renderSeriesDataFile: dataFile ]
		ifFalse: [ self abstract ]
]

{ #category : #accessing }
FOSeries >> blog [
	^ blog
]

{ #category : #accessing }
FOSeries >> blog: aFOBlog [
	blog := aFOBlog
]

{ #category : #accessing }
FOSeries >> partCount [
	^ self posts size
]

{ #category : #accessing }
FOSeries >> pathString [
	^ blog pathString, '/series/', slug, '.html'
]

{ #category : #accessing }
FOSeries >> posts [
	^ posts
]

{ #category : #accessing }
FOSeries >> posts: aCollection [
	posts := aCollection
]

{ #category : #accessing }
FOSeries >> slug [
	^ slug
]

{ #category : #accessing }
FOSeries >> slug: aString [
	slug := aString
]

{ #category : #accessing }
FOSeries >> title [
	^ self class titleFromSlug: slug
]

{ #category : #accessing }
FOSeries >> website [
	^ blog website
]

{ #category : #accessing }
FOSeries >> abstractLayout [
	^ 'series-abstract'
]

{ #category : #accessing }
FOSeries >> abstractTemplate [
	^ (self website templatePathForLayout: self abstractLayout) asMustacheTemplate
]

{ #category : #rendering }
FOSeries >> renderAbstract [
	^ (FOSeriesRenderContext new website: self website; series: self; yourself)
		renderTemplate: self abstractTemplate
]
