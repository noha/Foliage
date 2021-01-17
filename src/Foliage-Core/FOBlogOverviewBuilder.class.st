Class {
	#name : #FOBlogOverviewBuilder,
	#superclass : #Object,
	#instVars : [
		'posts',
		'numberOfCharacters'
	],
	#category : #'Foliage-Core-Blog'
}

{ #category : #accessing }
FOBlogOverviewBuilder >> amountOfCharacters [
	^ numberOfCharacters ifNil: [ 
		numberOfCharacters := self defaultNumberOfCharacters ]
]

{ #category : #building }
FOBlogOverviewBuilder >> buildAbstract: aPage [
	^ FOPillarTruncateVisitor new 
		amountOfCharacters: self amountOfCharacters;
		post: aPage 
]

{ #category : #building }
FOBlogOverviewBuilder >> buildSummary [
	|  abstracts |
	abstracts := self publishedPosts collect: [ :post |
		self buildAbstract: post ].
	self flag: #todo.
	"how to organite layouts for in-memory pages??"
	^ FOPillarPage new 
		metaAt: 'layout' put: 'page';
		metaAt: 'title' put: 'blog overview';
		pillar: (PRDocument new
			setChildren: (abstracts flatCollect: #children);
			yourself)
]

{ #category : #accessing }
FOBlogOverviewBuilder >> defaultNumberOfCharacters [
	^ 500
]

{ #category : #accessing }
FOBlogOverviewBuilder >> numberOfCharacters: anObject [
	numberOfCharacters := anObject
]

{ #category : #accessing }
FOBlogOverviewBuilder >> posts: aCollection [ 
	posts := aCollection
]

{ #category : #'page creation' }
FOBlogOverviewBuilder >> publishedPosts [
	^ (posts select: #isPublished)
			sorted: [ :a :b | a publishDate > b publishDate ]
]
