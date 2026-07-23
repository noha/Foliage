Class {
	#name : #FOSeriesIndexBuilder,
	#superclass : #Object,
	#instVars : [
		'blog'
	],
	#category : #'Foliage-Core-Blog'
}

{ #category : #accessing }
FOSeriesIndexBuilder >> blog: aBlog [
	blog := aBlog
]

{ #category : #building }
FOSeriesIndexBuilder >> buildPage [
	"One entry per series, each rendered through the 'series-abstract'
	template via FOSeries>>renderAbstract (title/pathString/abstract/
	partCount) - same bodyHtml/outer-template approach as
	FOBlogOverviewBuilder/FOSeriesOverviewBuilder, listing blog series
	(newest-active-first, see FOBlog>>series) instead of individual posts."
	| html |
	html := String streamContents: [ :s |
		blog series do: [ :aSeries | s nextPutAll: aSeries renderAbstract ] ].
	^ FOFoliagePage new
		parent: blog parent;
		title: 'Series';
		layout: blog layout;
		bodyHtml: html;
		yourself
]
