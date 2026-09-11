Class {
	#name : #FOBlogPostRenderContext,
	#superclass : #FOPageRenderContext,
	#category : #'Foliage-Core-Blog'
}

{ #category : #accessing }
FOBlogPostRenderContext >> abstract [
	^ self page abstract
]

{ #category : #accessing }
FOBlogPostRenderContext >> nextPost [
	^ page parent postAfter: self page
]

{ #category : #accessing }
FOBlogPostRenderContext >> pathString [
	^ page pathString
]

{ #category : #accessing }
FOBlogPostRenderContext >> previousPost [
	^ page parent postBefore: self page
]

{ #category : #series }
FOBlogPostRenderContext >> hasSeries [
	^ self page hasSeries
]

{ #category : #series }
FOBlogPostRenderContext >> seriesTitle [
	^ FOSeries titleFromSlug: self page series
]

{ #category : #series }
FOBlogPostRenderContext >> seriesPartNumber [
	^ (page parent postsInSeries: self page series) indexOf: self page
]

{ #category : #series }
FOBlogPostRenderContext >> seriesPartCount [
	^ (page parent postsInSeries: self page series) size
]

{ #category : #series }
FOBlogPostRenderContext >> seriesOverviewPath [
	^ page parent pathString, '/series/', self page series, '.html'
]

{ #category : #series }
FOBlogPostRenderContext >> seriesTeaser [
	^ (page parent seriesNamed: self page series) teaser
]

{ #category : #series }
FOBlogPostRenderContext >> seriesPreviousPost [
	^ page parent seriesPostBefore: self page
]

{ #category : #series }
FOBlogPostRenderContext >> seriesNextPost [
	^ page parent seriesPostAfter: self page
]

{ #category : #tags }
FOBlogPostRenderContext >> hasTags [
	^ self page hasTags
]

{ #category : #tags }
FOBlogPostRenderContext >> tagsHtml [
	"Templates here never iterate raw collections (see FOBlogOverviewBuilder/
	FOSeriesOverviewBuilder - multi-item HTML is always assembled in
	Smalltalk). Same idiom for a post's own tag list."
	^ String streamContents: [ :s |
		self page tags
			do: [ :slug |
				s nextPutAll: '<a href="', page parent pathString, '/tags/', slug, '/index.html">',
					(FOTag titleFromSlug: slug), '</a>' ]
			separatedBy: [ s nextPutAll: ', ' ] ]
]
