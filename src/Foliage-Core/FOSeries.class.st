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
	"Reuses the first (oldest, i.e. reading-order-first) post's own already-
	truncated abstract - same zero-config reasoning as titleFromSlug:, no
	separate series-description field/registry needed yet."
	^ self posts first abstract
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
