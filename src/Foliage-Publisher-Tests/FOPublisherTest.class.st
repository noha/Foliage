Class {
	#name : #FOPublisherTest,
	#superclass : #TestCase,
	#instVars : [
		'tempDir',
		'publisher'
	],
	#category : #'Foliage-Publisher-Tests'
}

{ #category : #running }
FOPublisherTest >> setUp [
	super setUp.
	tempDir := FileLocator temp / ('fo-publisher-test-', UUID new asString36).
	tempDir ensureCreateDirectory.
	(tempDir / 'source' / 'blog') ensureCreateDirectory.
	(tempDir / 'source' / 'templates') ensureCreateDirectory.
	(tempDir / 'source' / 'blog' / 'jan.md') writeStreamDo: [ :s |
		s nextPutAll: 'title: Jan post', String lf,
			'layout: blog-post', String lf,
			'publishDate: 2020-01-01', String lf,
			String lf,
			'January text.' ].
	(tempDir / 'source' / 'templates' / 'blog-post') writeStreamDo: [ :s |
		s nextPutAll: '<html><title>{{page.title}}</title>{{{ body }}}</html>' ].
	(tempDir / 'source' / 'templates' / 'blog') writeStreamDo: [ :s |
		s nextPutAll: '<html><title>{{page.title}}</title>{{{ body }}}</html>' ].
	(tempDir / 'source' / 'templates' / 'blog-post-abstract') writeStreamDo: [ :s |
		s nextPutAll: '<article>{{abstract}}</article>' ].
	(tempDir / 'source' / 'templates' / 'rss.xml') writeStreamDo: [ :s |
		s nextPutAll: '<rss>{{# channels }}<channel>{{# items }}<item><title>{{title}}</title></item>{{/ items }}</channel>{{/ channels }}</rss>' ].
	publisher := FOPublisher new
		baseUri: 'https://example.test';
		sourcePath: (tempDir / 'source') fullName;
		targetPath: (tempDir / 'generated') fullName;
		templatePath: 'templates';
		blogs: { #blog -> 'My Blog' };
		yourself
]

{ #category : #running }
FOPublisherTest >> tearDown [
	tempDir ifNotNil: [ tempDir exists ifTrue: [ tempDir deleteAll ] ].
	super tearDown
]

{ #category : #tests }
FOPublisherTest >> testPublishGeneratesPostOverviewAndFeed [
	publisher publish.
	self assert: (tempDir / 'generated' / 'blog' / 'jan.html') exists.
	self assert: (tempDir / 'generated' / 'blog' / 'index.html') exists.
	self assert: (tempDir / 'generated' / 'blog' / 'rss.xml') exists.
	self assert: ((tempDir / 'generated' / 'blog' / 'jan.html') contents includesSubstring: 'January text.').
	self assert: ((tempDir / 'generated' / 'blog' / 'index.html') contents includesSubstring: 'January text.').
	self assert: ((tempDir / 'generated' / 'blog' / 'rss.xml') contents includesSubstring: 'Jan post')
]

{ #category : #tests }
FOPublisherTest >> testPublishPaginatesOverviewPastDefaultPageSizeOfTen [
	"jan.md (from setUp) plus 10 more posts = 11 published posts total,
	one more than the default page size of 10 - should split into
	index.html (10 newest) + page2.html (1 oldest, with a 'more' link
	from index.html pointing to it)."
	1 to: 10 do: [ :n |
		(tempDir / 'source' / 'blog' / ('post', n printString, '.md')) writeStreamDo: [ :s |
			s nextPutAll: 'title: Post ', n printString, String lf,
				'layout: blog-post', String lf,
				'publishDate: 2020-02-', (n + 10) printString, String lf,
				String lf,
				'Post ', n printString, ' text.' ] ].
	publisher publish.
	self assert: (tempDir / 'generated' / 'blog' / 'index.html') exists.
	self assert: (tempDir / 'generated' / 'blog' / 'page2.html') exists.
	self assert: ((tempDir / 'generated' / 'blog' / 'index.html') contents includesSubstring: 'href="/blog/page2.html">more</a>').
	self assert: ((tempDir / 'generated' / 'blog' / 'index.html') contents includesSubstring: 'January text.') not.
	self assert: ((tempDir / 'generated' / 'blog' / 'page2.html') contents includesSubstring: 'January text.')
]

{ #category : #tests }
FOPublisherTest >> testDefaults [
	| fresh |
	fresh := FOPublisher new.
	self assert: fresh sourcePath equals: '.'.
	self assert: fresh targetPath equals: 'generated'.
	self assert: fresh templatePath equals: 'templates'.
	self assert: fresh blogs isEmpty
]
