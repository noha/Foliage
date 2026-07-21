Class {
	#name : #FORSSVisitor,
	#superclass : #FOModelVisitor,
	#category : #'Foliage-Core-RSS'
}

{ #category : #visiting }
FORSSVisitor >> visitBlog: aFOBlog [
	"channel title/link/description are derived from the blog itself, not
	hardcoded to one specific site's domain - the old code had
	'https://norbert.hartl.name/blog/rss.xml' and 'fo' literally in the
	library source, which would have been wrong for any other site loading
	Foliage as-is. Also uses publishedPosts, not posts - the old code fed
	*all* posts (including unpublished drafts) into the RSS feed, which
	would have leaked draft content to subscribers.

	publishedPosts itself is unsorted (raw dictionary iteration order) - a
	real 9-post dry run against noha.github.io surfaced items appearing in
	filesystem order instead of newest-first, unlike the blog overview page
	(FOBlogOverviewBuilder>>publishedPosts already sorts descending). RSS
	items should match that same newest-first convention."
	| feed channel |
	feed := FORSSFeed new.
	channel := FORSSChannel new
		title: aFOBlog title;
		link: aFOBlog absoluteLink;
		description: aFOBlog title.
	channel items: (self visitAll: (aFOBlog publishedPosts sorted: #publishDate descending)).
	feed addChannel: channel.
	^ feed
]

{ #category : #visiting }
FORSSVisitor >> visitBlogPost: aFOBlogPost [
	^ self visitFoliagePage: aFOBlogPost
]

{ #category : #visiting }
FORSSVisitor >> visitFoliagePage: aFOFoliagePage [
	^ FORSSItem new
		title: aFOFoliagePage title;
		link: aFOFoliagePage absoluteLink;
		description: aFOFoliagePage abstract
]
