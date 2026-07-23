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
	expected to be short enough that all parts fit on one page.

	A hand-written data/series/<slug>.md, if present, is shown as an intro
	paragraph before the list of post abstracts - only when it actually
	exists (series abstract already falls back to the first post's own
	abstract otherwise, which would just duplicate that post's text if shown
	here unconditionally). Plain text, not the templated series-abstract
	listing entry (title+link+partCount) - that wrapper makes sense in a
	list of several series, not as this page's own intro to itself."
	| html |
	html := String streamContents: [ :s |
		series hasCustomAbstract ifTrue: [
			s nextPutAll: '<p>', series abstract, '</p>' ].
		series posts do: [ :post | s nextPutAll: post renderAbstract ] ].
	^ FOFoliagePage new
		parent: blog parent;
		title: series title;
		layout: blog layout;
		bodyHtml: html;
		yourself
]
