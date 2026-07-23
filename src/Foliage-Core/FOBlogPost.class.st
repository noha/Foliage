Class {
	#name : #FOBlogPost,
	#superclass : #FOFoliagePage,
	#category : #'Foliage-Core-Blog'
}

{ #category : #accessing }
FOBlogPost >> abstract [
	| fullText |
	fullText := FOPlainTextVisitor render: self document.
	^ fullText first: (fullText size min: self abstractAmountOfCharacters)
]

{ #category : #accessing }
FOBlogPost >> abstractAmountOfCharacters [
	^ 400
]

{ #category : #accessing }
FOBlogPost >> abstractLayout [
	^ self meta
		at: #abstractLayout
		ifAbsent: [ self defaultAbstractLayout ]
]

{ #category : #accessing }
FOBlogPost >> abstractTemplate [
	^ (self website templatePathForLayout: self abstractLayout) asMustacheTemplate
]

{ #category : #visiting }
FOBlogPost >> acceptFOVisitor: aFOVisitor [
	^ aFOVisitor visitBlogPost: self
]

{ #category : #accessing }
FOBlogPost >> defaultAbstractLayout [
	^ 'blog-post-abstract'
]

{ #category : #accessing }
FOBlogPost >> defaultLayout [
	"The old code's default here was 'blogpost' (no hyphen), which never
	matches the actual template file name ('blog-post') or the layout real
	content always sets explicitly in its own frontmatter - fixed to match,
	since a post that ever fell back to this default would otherwise fail to
	find its template."
	^ 'blog-post'
]

{ #category : #testing }
FOBlogPost >> hasSeries [
	^ self series notNil
]

{ #category : #testing }
FOBlogPost >> isPost [
	^ true
]

{ #category : #accessing }
FOBlogPost >> renderAbstract [
	^ self newRenderContext renderTemplate: self abstractTemplate
]

{ #category : #accessing }
FOBlogPost >> series [
	"The frontmatter 'series: <slug>' key, e.g. 'series: soil' - a post
	belongs to at most one series; absent means it isn't part of one."
	^ self meta at: #series ifAbsent: [ nil ]
]

{ #category : #'instance creation' }
FOBlogPost >> renderContextClass [
	^ FOBlogPostRenderContext
]
