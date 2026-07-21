Class {
	#name : #FORSSVisitorTest,
	#superclass : #TestCase,
	#instVars : [
		'site',
		'blog'
	],
	#category : #'Foliage-Core-Tests'
}

{ #category : #running }
FORSSVisitorTest >> setUp [
	super setUp.
	site := FOWebSite new baseUri: 'https://example.test'; yourself.
	blog := FOBlog new title: 'My Blog'; yourself.
	site root at: #blog put: blog
]

{ #category : #private }
FORSSVisitorTest >> makePostTitled: aTitle publishDate: aDateString text: aText [
	^ FOFoliagePage new
		meta: (Dictionary new
			at: #title put: aTitle;
			at: #publishDate put: aDateString;
			yourself);
		document: (FOMarkdownParser parse: aText);
		yourself
]

{ #category : #tests }
FORSSVisitorTest >> testFeedChannelIsDerivedFromBlogNotHardcoded [
	| feed channel |
	feed := FORSSVisitor new visit: blog.
	self assert: (feed isKindOf: FORSSFeed).
	self assert: feed channels size equals: 1.
	channel := feed channels first.
	self assert: channel title equals: 'My Blog'.
	self assert: channel link asString equals: 'https://example.test/blog'.
	self assert: channel description equals: 'My Blog'
]

{ #category : #tests }
FORSSVisitorTest >> testChannelItemsComeOnlyFromPublishedPosts [
	| channel |
	blog at: #jan put: (self makePostTitled: 'Jan post' publishDate: '2020-01-01' text: 'January text.').
	blog at: #draft put: (self makePostTitled: 'Draft' publishDate: '' text: 'Not published.').
	channel := (FORSSVisitor new visit: blog) channels first.
	self assert: channel items size equals: 1.
	self assert: channel items first title equals: 'Jan post'.
	self assert: channel items first link asString equals: 'https://example.test/blog/jan.html'.
	self assert: channel items first description equals: 'January text.'
]

{ #category : #tests }
FORSSVisitorTest >> testChannelItemsAreOrderedNewestFirstRegardlessOfInsertionOrder [
	"A real 9-post dry run against noha.github.io surfaced this: publishedPosts
	is unsorted (raw dictionary/filesystem order), so inserting posts out of
	date order used to leak straight into the feed's item order."
	| channel |
	blog at: #feb put: (self makePostTitled: 'Feb post' publishDate: '2020-02-01' text: 'Feb text.').
	blog at: #jan put: (self makePostTitled: 'Jan post' publishDate: '2020-01-01' text: 'Jan text.').
	blog at: #mar put: (self makePostTitled: 'Mar post' publishDate: '2020-03-01' text: 'Mar text.').
	channel := (FORSSVisitor new visit: blog) channels first.
	self assert: (channel items collect: #title) asArray
		equals: #('Mar post' 'Feb post' 'Jan post')
]
