Class {
	#name : #FOBlogOverviewBuilder,
	#superclass : #Object,
	#instVars : [
		'blog',
		'numberOfCharacters'
	],
	#category : #'Foliage-Core-Blog'
}

{ #category : #accessing }
FOBlogOverviewBuilder >> amountOfCharacters [
	^ numberOfCharacters ifNil: [ 
		numberOfCharacters := self defaultNumberOfCharacters ]
]

{ #category : #accessing }
FOBlogOverviewBuilder >> blog: aBlog [

	blog := aBlog
]

{ #category : #building }
FOBlogOverviewBuilder >> buildAbstract: aPage [
	
	^ PRRaw content: aPage renderAbstract
]

{ #category : #building }
FOBlogOverviewBuilder >> buildSummary [
	| abstracts |

	abstracts := self publishedPosts 
		collect: [ :post | self buildAbstract: post ].

	self flag: #todo.
	"how to organite layouts for in-memory pages??"
	^ FOBlogPage new 
		metaAt: 'layout' put: blog layout;
		metaAt: 'title' put: blog title;
		parent: blog parent;
		pillar: (PRDocument new
			setChildren: abstracts;
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

{ #category : #'page creation' }
FOBlogOverviewBuilder >> publishedPosts [

	^ (blog posts select: #isPublished) sorted: #publishDate descending
]
