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
		ifTrue: [ self renderDataAbstract: dataFile ]
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
FOSeries >> renderDataAbstract: aFileReference [
	| frontmatter |
	frontmatter := FOFrontmatterParser parse: aFileReference contents.
	^ FOPlainTextVisitor render: (FOMarkdownParser parse: frontmatter body)
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
