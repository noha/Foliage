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
		aPageNumber < aPageCount ifTrue: [
			s nextPutAll: (self moreLinkHtmlFor: aPageNumber + 1) ] ].
	^ FOFoliagePage new
		parent: blog parent;
		title: blog title;
		layout: blog layout;
		bodyHtml: html;
		yourself
]

{ #category : #building }
FOBlogOverviewBuilder >> moreLinkHtmlFor: aNextPageNumber [
	"Absolute (blog-rooted) path, not a bare relative filename: the same
	rendered page content is reused verbatim as both blog/pageN.html AND -
	in this site's own build script - the site's root index.html, where a
	relative 'page2.html' would wrongly resolve to /page2.html instead of
	/blog/page2.html."
	^ '<p><a href="', blog pathString, '/', (self class pageFilenameFor: aNextPageNumber), '">more</a></p>'
]

{ #category : #accessing }
FOBlogOverviewBuilder >> publishedPosts [
	^ (blog posts select: #isPublished) sorted: #publishDate descending
]
