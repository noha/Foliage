Class {
	#name : #FOPageRenderContext,
	#superclass : #FORenderContext,
	#instVars : [
		'page'
	],
	#category : #'Foliage-Core-Base'
}

{ #category : #accessing }
FOPageRenderContext >> body [
	^ self html
]

{ #category : #accessing }
FOPageRenderContext >> html [
	^ String streamContents: [ :s | page renderOn: s ]
]

{ #category : #accessing }
FOPageRenderContext >> layout [
	^ page layout
]

{ #category : #accessing }
FOPageRenderContext >> page [
	^ page
]

{ #category : #accessing }
FOPageRenderContext >> page: anObject [
	page := anObject
]

{ #category : #accessing }
FOPageRenderContext >> publicationDate [
	"Keeps the Mustache-facing name the real templates actually use
	(noha.github.io/templates/blog-post-abstract references
	{{{publicationDate}}}) - the original bug was the delegation target
	(page publicationDate, which never existed on the page class, only
	page publishDate did), not this method's own name. Renaming this to
	match the page-side name instead (an earlier attempt at fixing it) would
	have broken every real template using this key - caught by actually
	checking real template content for step 25, not assumed."
	^ page publishDate
]

{ #category : #accessing }
FOPageRenderContext >> title [
	^ page title
]
