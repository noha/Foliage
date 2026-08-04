Class {
	#name : #FOTagOverviewBuilder,
	#superclass : #Object,
	#instVars : [
		'blog',
		'tag',
		'pageSize'
	],
	#category : #'Foliage-Core-Blog'
}

{ #category : #accessing }
FOTagOverviewBuilder >> blog: aBlog [
	blog := aBlog
]

{ #category : #accessing }
FOTagOverviewBuilder >> tag: aFOTag [
	tag := aFOTag
]

{ #category : #accessing }
FOTagOverviewBuilder >> defaultPageSize [
	^ 10
]

{ #category : #accessing }
FOTagOverviewBuilder >> pageSize [
	^ pageSize ifNil: [ self defaultPageSize ]
]

{ #category : #accessing }
FOTagOverviewBuilder >> pageSize: anInteger [
	pageSize := anInteger
]

{ #category : #building }
FOTagOverviewBuilder >> buildPages [
	"Paginated like FOBlogOverviewBuilder, unlike FOSeriesOverviewBuilder's
	single-page assumption - a tag can accumulate many posts over the
	lifetime of a blog, unlike a series. tag posts is already newest-first
	(set by FOBlog>>tags), so no re-sorting needed here."
	| posts pageCount |
	posts := tag posts.
	pageCount := (posts size / self pageSize) ceiling max: 1.
	^ (1 to: pageCount) collect: [ :i |
		self
			buildPageIndex: i
			ofTotal: pageCount
			posts: posts ]
]

{ #category : #building }
FOTagOverviewBuilder >> buildPageIndex: aPageNumber ofTotal: aPageCount posts: allPosts [
	"Same bodyHtml/outer-template approach as FOBlogOverviewBuilder. A hand-
	written data/tags/<slug>.md abstract, if present, is shown as an intro
	paragraph - only on page 1, not repeated on every page."
	| start stop pagePosts html |
	start := (aPageNumber - 1) * self pageSize + 1.
	stop := (aPageNumber * self pageSize) min: allPosts size.
	pagePosts := start <= allPosts size
		ifTrue: [ allPosts copyFrom: start to: stop ]
		ifFalse: [ #() ].
	html := String streamContents: [ :s |
		(aPageNumber = 1 and: [ tag hasCustomAbstract ])
			ifTrue: [ s nextPutAll: '<p>', tag abstract, '</p>' ].
		pagePosts do: [ :post | s nextPutAll: post renderAbstract ].
		s nextPutAll: (self navigationHtmlForPageIndex: aPageNumber ofTotal: aPageCount) ].
	^ FOFoliagePage new
		parent: blog parent;
		title: tag title;
		layout: blog layout;
		bodyHtml: html;
		yourself
]

{ #category : #building }
FOTagOverviewBuilder >> navigationHtmlForPageIndex: aPageNumber ofTotal: aPageCount [
	"Same layout/wording as FOBlogOverviewBuilder>>navigationHtmlForPageIndex:
	ofTotal:, but rooted under this tag's own folder
	(blog/tags/<slug>/...) rather than the blog root - so it can't reuse that
	method directly. Filename computation itself (index.html/pageN.html) is
	reused via FOBlogOverviewBuilder class>>pageFilenameFor:, which is
	stateless and tag-agnostic."
	| base newerLink olderLink |
	base := blog pathString, '/tags/', tag slug.
	newerLink := aPageNumber > 1
		ifTrue: [ '&lt;-- <a href="', base, '/', (FOBlogOverviewBuilder pageFilenameFor: aPageNumber - 1), '">newer</a>' ]
		ifFalse: [ '' ].
	olderLink := aPageNumber < aPageCount
		ifTrue: [ '<a href="', base, '/', (FOBlogOverviewBuilder pageFilenameFor: aPageNumber + 1), '">older</a> --&gt;' ]
		ifFalse: [ '' ].
	(newerLink isEmpty and: [ olderLink isEmpty ]) ifTrue: [ ^ '' ].
	^ '<div style="display: grid; grid-template-columns: 1fr 1fr; margin-top: 2em;">
	<div style="text-align: left;">', newerLink, '</div>
	<div style="text-align: right;">', olderLink, '</div>
</div>'
]
