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
	"'newer' always sits bottom-left (with a left arrow), 'older' always
	bottom-right. Uses an actual CSS grid (two fixed 1fr columns) instead of
	Skeleton's float-based row/columns classes - those are meant for
	top-level layout rows and visibly misaligned here because this row ends
	up nested inside the blog template's own '.twelve.columns' body column
	rather than being a sibling row at the '.container' level (unlike the
	blog-post template's previousPost/nextPost row, which isn't nested).
	A plain 2-column grid doesn't care about that nesting and keeps both
	slots fixed in place even when only one link is present. Deliberately
	the mirror image of blog-post's own left/right assignment (there,
	older/previousPost is on the left) - this is what was explicitly asked
	for here, not an inconsistency. Absolute (blog-rooted) paths for the
	same reason as pageFilenameFor: callers elsewhere: this same rendered
	body is reused verbatim as the site's root index.html too, where a
	relative filename would resolve wrong."
	| newerLink olderLink |
	newerLink := aPageNumber > 1
		ifTrue: [ '&lt;-- <a href="', blog pathString, '/', (self class pageFilenameFor: aPageNumber - 1), '">newer</a>' ]
		ifFalse: [ '' ].
	olderLink := aPageNumber < aPageCount
		ifTrue: [ '<a href="', blog pathString, '/', (self class pageFilenameFor: aPageNumber + 1), '">older</a> --&gt;' ]
		ifFalse: [ '' ].
	(newerLink isEmpty and: [ olderLink isEmpty ]) ifTrue: [ ^ '' ].
	^ '<div style="display: grid; grid-template-columns: 1fr 1fr; margin-top: 2em;">
	<div style="text-align: left;">', newerLink, '</div>
	<div style="text-align: right;">', olderLink, '</div>
</div>'
]

{ #category : #accessing }
FOBlogOverviewBuilder >> publishedPosts [
	^ (blog posts select: #isPublished) sorted: #publishDate descending
]
