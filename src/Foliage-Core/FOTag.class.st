Class {
	#name : #FOTag,
	#superclass : #Object,
	#instVars : [
		'slug',
		'posts',
		'blog'
	],
	#category : #'Foliage-Core-Blog'
}

{ #category : #'instance creation' }
FOTag class >> titleFromSlug: aSlug [
	"'soil' -> 'Soil', 'byob-database' -> 'Byob Database'. Same zero-config
	stand-in as FOSeries class>>titleFromSlug: - deliberately duplicated
	rather than shared, see FOTag class comment / roadmap notes."
	^ String streamContents: [ :s |
		(aSlug substrings: '-') do: [ :word |
			s nextPutAll: word first asUppercase asString.
			word size > 1 ifTrue: [ s nextPutAll: (word copyFrom: 2 to: word size) ] ]
		separatedBy: [ s nextPut: $  ] ]
]

{ #category : #accessing }
FOTag >> abstract [
	"A hand-written data/tags/<slug>.md overrides the auto-derived abstract,
	if present - same mechanism as FOSeries>>abstract. Falls back to the
	NEWEST post's abstract (posts first, since tag posts are stored newest-
	first) when no such file exists - unlike FOSeries, a tag has no 'part 1',
	so the most recent post is the most sensible representative excerpt."
	| dataFile |
	dataFile := self dataAbstractFile.
	^ dataFile exists
		ifTrue: [ self renderDataAbstract: dataFile ]
		ifFalse: [ self posts first abstract ]
]

{ #category : #accessing }
FOTag >> dataAbstractFile [
	^ (self website dataPath / 'tags' / (slug, '.md')) asFileReference
]

{ #category : #testing }
FOTag >> hasCustomAbstract [
	^ self dataAbstractFile exists
]

{ #category : #accessing }
FOTag >> renderDataAbstract: aFileReference [
	| frontmatter |
	frontmatter := FOFrontmatterParser parse: aFileReference contents.
	^ FOPlainTextVisitor render: (FOMarkdownParser parse: frontmatter body)
]

{ #category : #accessing }
FOTag >> blog [
	^ blog
]

{ #category : #accessing }
FOTag >> blog: aFOBlog [
	blog := aFOBlog
]

{ #category : #accessing }
FOTag >> postCount [
	^ self posts size
]

{ #category : #accessing }
FOTag >> pathString [
	^ blog pathString, '/tags/', slug, '/index.html'
]

{ #category : #accessing }
FOTag >> posts [
	^ posts
]

{ #category : #accessing }
FOTag >> posts: aCollection [
	posts := aCollection
]

{ #category : #accessing }
FOTag >> slug [
	^ slug
]

{ #category : #accessing }
FOTag >> slug: aString [
	slug := aString
]

{ #category : #accessing }
FOTag >> title [
	^ self class titleFromSlug: slug
]

{ #category : #accessing }
FOTag >> website [
	^ blog website
]

{ #category : #accessing }
FOTag >> abstractLayout [
	^ 'tag-abstract'
]

{ #category : #accessing }
FOTag >> abstractTemplate [
	^ (self website templatePathForLayout: self abstractLayout) asMustacheTemplate
]

{ #category : #rendering }
FOTag >> renderAbstract [
	^ (FOTagRenderContext new website: self website; tag: self; yourself)
		renderTemplate: self abstractTemplate
]
