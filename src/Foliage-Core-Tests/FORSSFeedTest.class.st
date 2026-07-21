Class {
	#name : #FORSSFeedTest,
	#superclass : #TestCase,
	#instVars : [
		'tempDir',
		'site',
		'blog'
	],
	#category : #'Foliage-Core-Tests'
}

{ #category : #running }
FORSSFeedTest >> setUp [
	super setUp.
	tempDir := FileLocator temp / ('fo-rss-feed-test-', UUID new asString36).
	tempDir ensureCreateDirectory.
	(tempDir / 'templates') ensureCreateDirectory.
	"An inlined copy of noha.github.io/templates/rss.xml, portable (no absolute
	sibling-repo path), same reasoning as FOMarkdownReaderTest/
	FOMarkdownIntegrationTest."
	(tempDir / 'templates' / 'rss.xml') writeStreamDo: [ :s |
		s nextPutAll: '<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
{{# channels }}
<channel>
    <title>{{title}}</title>
    <link>{{link}}</link>
    <atom:link href="{{link}}" rel="self" type="application/rss+xml" />
    <description>{{description}}</description>
  {{# items }}
  <item>
      <title>{{title}}</title>
      <link>{{link}}</link>
      <description>{{description}}</description>
  </item>
  {{/ items}}
</channel>
{{/ channels }}
</rss>' ].
	(tempDir / 'templates' / 'blog-post') writeStreamDo: [ :s |
		s nextPutAll: '<html><title>{{page.title}}</title>{{{ body }}}</html>' ].
	site := FOWebSite new
		baseUri: 'https://example.test';
		targetPath: (tempDir / 'docs');
		templatePath: (tempDir / 'templates');
		yourself.
	blog := FOBlog new title: 'My Blog'; yourself.
	site root at: #blog put: blog
]

{ #category : #running }
FORSSFeedTest >> tearDown [
	tempDir ifNotNil: [ tempDir exists ifTrue: [ tempDir deleteAll ] ].
	super tearDown
]

{ #category : #tests }
FORSSFeedTest >> testPathStringForcesXmlExtensionNotHtml [
	blog at: #'rss.xml' put: blog rssFeed.
	self assert: (blog / #'rss.xml') pathString equals: '/blog/rss.xml'
]

{ #category : #tests }
FORSSFeedTest >> testFullFeedPublishesThroughRealTemplate [
	| post publishedFile content |
	post := FOFoliagePage new
		meta: (Dictionary new at: #title put: 'Jan post'; at: #publishDate put: '2020-01-01'; yourself);
		document: (FOMarkdownParser parse: 'January text.');
		yourself.
	blog at: #jan put: post.
	blog at: #'rss.xml' put: blog rssFeed.
	FOPublishVisitor new start: site.
	publishedFile := tempDir / 'docs' / 'blog' / 'rss.xml'.
	self assert: publishedFile exists.
	content := publishedFile contents.
	self assert: (content includesSubstring: '<title>My Blog</title>').
	self assert: (content includesSubstring: '<title>Jan post</title>').
	self assert: (content includesSubstring: '<description>January text.</description>').
	self assert: (content includesSubstring: 'https://example.test/blog/jan.html')
]
