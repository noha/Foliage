Class {
	#name : #FOBlogOverviewBuilder,
	#superclass : #Object,
	#instVars : [
		'blog'
	],
	#category : #'Foliage-Core-Blog'
}

{ #category : #accessing }
FOBlogOverviewBuilder >> blog: aBlog [
	blog := aBlog
]

{ #category : #building }
FOBlogOverviewBuilder >> buildSummary [
	"No Pillar wrapper (the old code built a fake PRDocument/PRRaw tree just to
	push pre-rendered HTML through the same Pillar pipeline - that's what its
	'#todo: how to organize layouts for in-memory pages??' was about). Instead:
	an FOFoliagePage with metadata, its bodyHtml set directly to the
	concatenation of each post's independently-rendered abstract. This still
	goes through the normal #render/#template pipeline (the blog's own outer
	layout, {{page.title}}, partials, ...) since #renderOn: uses bodyHtml only
	for the body slot, not to bypass templating altogether.

	Must be an FOFoliagePage specifically, not a plain FOPageWithMetadata: the
	publish visitor dispatches on acceptFOVisitor:, and FOPageWithMetadata
	inherits FOHTMLPage's dispatch to visitHTMLPageSource: (treats it as a
	file to copy from sourcePath, which this synthetic page doesn't have) -
	FOFoliagePage dispatches to visitFoliagePage: (calls #publish), which is
	what a page built from in-memory content actually needs."
	| html |
	html := String streamContents: [ :s |
		self publishedPosts do: [ :post | s nextPutAll: post renderAbstract ] ].
	^ FOFoliagePage new
		parent: blog parent;
		title: blog title;
		layout: blog layout;
		bodyHtml: html;
		yourself
]

{ #category : #accessing }
FOBlogOverviewBuilder >> publishedPosts [
	^ (blog posts select: #isPublished) sorted: #publishDate descending
]
