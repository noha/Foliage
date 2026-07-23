Class {
	#name : #FOSeriesOverviewBuilder,
	#superclass : #Object,
	#instVars : [
		'blog',
		'series'
	],
	#category : #'Foliage-Core-Blog'
}

{ #category : #accessing }
FOSeriesOverviewBuilder >> blog: aBlog [
	blog := aBlog
]

{ #category : #accessing }
FOSeriesOverviewBuilder >> series: aFOSeries [
	series := aFOSeries
]

{ #category : #building }
FOSeriesOverviewBuilder >> buildPage [
	"Same approach as FOBlogOverviewBuilder (bodyHtml set directly to the
	concatenation of each post's rendered abstract, still going through the
	normal outer #render/#template pipeline) - no pagination here, series are
	expected to be short enough that all parts fit on one page."
	| html |
	html := String streamContents: [ :s |
		series posts do: [ :post | s nextPutAll: post renderAbstract ] ].
	^ FOFoliagePage new
		parent: blog parent;
		title: series title;
		layout: blog layout;
		bodyHtml: html;
		yourself
]
