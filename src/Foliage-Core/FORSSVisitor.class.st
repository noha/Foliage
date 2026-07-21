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
	would have leaked draft content to subscribers."
	| feed channel |
	feed := FORSSFeed new.
	channel := FORSSChannel new
		title: aFOBlog title;
		link: aFOBlog absoluteLink;
		description: aFOBlog title.
	channel items: (self visitAll: aFOBlog publishedPosts).
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
