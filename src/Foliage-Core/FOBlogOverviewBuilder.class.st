Class {
	#name : #FOBlogOverviewBuilder,
	#superclass : #Object,
	#instVars : [
		'blog',
		'pageSize'
	],
	#category : #'Foliage-Core-Blog'
}

{ #category : #'file names' }
FOBlogOverviewBuilder class >> pageFilenameFor: aPageNumber [
	"Page 1 is always the blog's own index.html (and, via FOPublisher/build
	scripts, typically also mirrored as the site's root index.html) - every
	later page is a flat pageN.html sibling, consistent with this site's
	existing flat .html-per-resource convention (no nested page/N/ folders)."
	^ aPageNumber = 1
		ifTrue: [ #'index.html' ]
		ifFalse: [ ('page', aPageNumber printString, '.html') asSymbol ]
]

{ #category : #accessing }
FOBlogOverviewBuilder >> blog: aBlog [
	blog := aBlog
]

{ #category : #accessing }
FOBlogOverviewBuilder >> defaultPageSize [
	^ 10
]

{ #category : #accessing }
FOBlogOverviewBuilder >> pageSize [
	^ pageSize ifNil: [ self defaultPageSize ]
]

{ #category : #accessing }
FOBlogOverviewBuilder >> pageSize: anInteger [
	pageSize := anInteger
]

{ #category : #building }
FOBlogOverviewBuilder >> buildPages [
	"One page per pageSize-sized slice of publishedPosts, newest-first
	(matches sorting already used before pagination existed). Zero posts
	still yields exactly one (empty) page, same as the pre-pagination
	behavior of always producing a valid overview page."
	| posts pageCount |
	posts := self publishedPosts.
	pageCount := (posts size / self pageSize) ceiling max: 1.
	^ (1 to: pageCount) collect: [ :i |
		self
			buildPageIndex: i
			ofTotal: pageCount
			posts: posts ]
]

{ #category : #building }
FOBlogOverviewBuilder >> buildPageIndex: aPageNumber ofTotal: aPageCount posts: allPosts [
	"No Pillar wrapper (the old code built a fake PRDocument/PRRaw tree just to
	push pre-rendered HTML through the same Pillar pipeline - that's what its
	'#todo: how to organize layouts for in-memory pages??' was about). Instead:
	an FOFoliagePage with metadata, its bodyHtml set directly to the
	concatenation of each post's independently-rendered abstract (plus a
	trailing 'more' link to the next page, if any). This still goes through
	the normal #render/#template pipeline (the blog's own outer layout,
	{{page.title}}, partials, ...) since #renderOn: uses bodyHtml only for
	the body slot, not to bypass templating altogether.

	Must be an FOFoliagePage specifically, not a plain FOPageWithMetadata: the
	publish visitor dispatches on acceptFOVisitor:, and FOPageWithMetadata
	inherits FOHTMLPage's dispatch to visitHTMLPageSource: (treats it as a
	file to copy from sourcePath, which this synthetic page doesn't have) -
	FOFoliagePage dispatches to visitFoliagePage: (calls #publish), which is
	what a page built from in-memory content actually needs."
	| start stop pagePosts html |
	start := (aPageNumber - 1) * self pageSize + 1.
	stop := (aPageNumber * self pageSize) min: allPosts size.
	pagePosts := start <= allPosts size
		ifTrue: [ allPosts copyFrom: start to: stop ]
		ifFalse: [ #() ].
	html := String streamContents: [ :s |
		pagePosts do: [ :post | s nextPutAll: post renderAbstract ].
		s nextPutAll: (self navigationHtmlForPageIndex: aPageNumber ofTotal: aPageCount) ].
	^ FOFoliagePage new
		parent: blog parent;
		title: blog title;
		layout: blog layout;
		bodyHtml: html;
		yourself
]

{ #category : #building }
FOBlogOverviewBuilder >> navigationHtmlForPageIndex: aPageNumber ofTotal: aPageCount [
	"Older posts live on later pages (higher page numbers), newer posts on
	earlier ones - mirrors the blog-post template's own previousPost (older,
	left)/nextPost (newer, right) convention, so 'older' is only shown when
	a later page exists and 'newer' only when an earlier one does: page 1
	gets only 'older', the last page gets only 'newer', pages in between get
	both. Absolute (blog-rooted) paths for the same reason as
	pageFilenameFor: callers elsewhere: this same rendered body is reused
	verbatim as the site's root index.html too, where a relative filename
	would resolve wrong."
	| links |
	links := OrderedCollection new.
	aPageNumber < aPageCount ifTrue: [
		links add: '<a href="', blog pathString, '/', (self class pageFilenameFor: aPageNumber + 1), '">older</a>' ].
	aPageNumber > 1 ifTrue: [
		links add: '<a href="', blog pathString, '/', (self class pageFilenameFor: aPageNumber - 1), '">newer</a>' ].
	links isEmpty ifTrue: [ ^ '' ].
	^ '<p>', (String streamContents: [ :s | links do: [ :l | s nextPutAll: l ] separatedBy: [ s nextPutAll: ' ' ] ]), '</p>'
]

{ #category : #accessing }
FOBlogOverviewBuilder >> publishedPosts [
	^ (blog posts select: #isPublished) sorted: #publishDate descending
]
