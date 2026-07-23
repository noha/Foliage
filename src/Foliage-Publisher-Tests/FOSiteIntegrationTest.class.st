Class {
	#name : #FOSiteIntegrationTest,
	#superclass : #TestCase,
	#instVars : [
		'tempDir',
		'publisher'
	],
	#category : #'Foliage-Publisher-Tests'
}

{ #category : #private }
FOSiteIntegrationTest >> nl [
	^ String with: Character lf
]

{ #category : #private }
FOSiteIntegrationTest >> writeFile: aRelativeName contents: aString [
	"FOPublisher>>publish uses sourcePath directly as contentPath (no further
	'content' subfolder), so content files live straight under tempDir/source."
	| file |
	file := tempDir / 'source' / aRelativeName.
	file parent ensureCreateDirectory.
	file writeStreamDo: [ :s | s nextPutAll: aString ]
]

{ #category : #private }
FOSiteIntegrationTest >> writeTemplate: aName contents: aString [
	"FOPublisher>>publish computes the site's templatePath as
	sourcePath / templatePath (relative to sourcePath, not a sibling of it) -
	so templates live under tempDir/source/templates, matching the
	publisher's own convention rather than NohaWebsite's sibling-folders one."
	| file |
	file := tempDir / 'source' / 'templates' / aName.
	file parent ensureCreateDirectory.
	file writeStreamDo: [ :s | s nextPutAll: aString ]
]

{ #category : #private }
FOSiteIntegrationTest >> aboutPageContent [
	"Inlined copy of noha.github.io/raw/about.md - note the real file has a
	space before the colon on its first frontmatter line ('title : About
	me'), which is deliberately kept as-is here since it already exercises
	FOFrontmatterParser's isValidKey: trimming (Phase 1)."
	^ 'title : About me', self nl,
		'layout: about', self nl,
		self nl,
		'# Hey!', self nl,
		self nl,
		'This site is all about programming. I started this site by just writing down one article and then started to build a system around to render to the web.', self nl,
		self nl,
		'I''m an enthusiast about programming and software construction. That''s why I''m part of the [pharo](http://pharo.org) community.'
]

{ #category : #private }
FOSiteIntegrationTest >> pickingItUpPostContent [
	"Inlined copy of noha.github.io/raw/blog/2022-12-03_picking-it-up.md,
	same fixture already used in FOMarkdownReaderTest."
	^ 'title: Picking it up', self nl,
		'layout: blog-post', self nl,
		'publishDate: 2022-12-03', self nl,
		self nl,
		'# Picking it up', self nl,
		self nl,
		'What happened so far? I did the usual thing. I created a blog and wrote a blog engine for it.', self nl,
		self nl,
		'This time it is different because it wasn''t the end of the project. Foliage got a new user which made me quite proud. After several years the site was changed to be produced by Foliage. It now runs stable and super fast thanks to [static site content](http://pharo.org).'
]

{ #category : #private }
FOSiteIntegrationTest >> byobPostContent [
	"A shorter inlined excerpt of noha.github.io/raw/blog/byob-build-your-own-database.md,
	exercising a list and bold text alongside the other post's links."
	^ 'title: BYOB - build your own (data)base', self nl,
		'layout: blog-post', self nl,
		'publishDate: 2023-01-07', self nl,
		self nl,
		'# BYOB - build your own (data)base', self nl,
		self nl,
		'Two things are important to consider:', self nl,
		self nl,
		'- objects reference each other building an object graph', self nl,
		'- an object is the combination of **state and behavior**', self nl,
		self nl,
		'That''s the basic idea behind [Soil](https://github.com/ApptiveGrid/Soil).'
]

{ #category : #running }
FOSiteIntegrationTest >> setUp [
	super setUp.
	tempDir := FileLocator temp / ('fo-site-integration-test-', UUID new asString36).
	tempDir ensureCreateDirectory.

	self writeFile: 'about.md' contents: self aboutPageContent.
	self writeFile: 'blog/2022-12-03_picking-it-up.md' contents: self pickingItUpPostContent.
	self writeFile: 'blog/byob-build-your-own-database.md' contents: self byobPostContent.

	"Inlined copies of the real noha.github.io/templates/* files (not read
	from the sibling repo's absolute path - portability lesson from
	FOMarkdownReaderTest)."
	self writeTemplate: 'page-header' contents:
		'<div class="container"><div class="row"><a href="/">home</a><a href="/blog/">blog</a><a href="/about.html">about</a></div></div>'.
	self writeTemplate: 'about' contents:
		'<html><head><title>{{page.title}}</title></head><body>{{> page-header}}<div class="row">{{{ body }}}</div></body></html>'.
	self writeTemplate: 'blog-post' contents:
		'<html><head><title>{{page.title}}</title></head><body>{{> page-header}}<div class="row">{{{ body }}}</div></body></html>'.
	self writeTemplate: 'blog' contents:
		'<html><head><title>{{page.title}}</title></head><body>{{> page-header}}<div class="row">{{{ body }}}</div></body></html>'.
	self writeTemplate: 'blog-post-abstract' contents:
		'<div><h3><a href="{{pathString}}">{{title}}</a></h3>{{abstract}}<div class="date"><i>{{{publicationDate}}}</i></div></div>'.
	self writeTemplate: 'rss.xml' contents:
		'<?xml version="1.0" encoding="UTF-8" ?><rss version="2.0">{{# channels }}<channel><title>{{title}}</title><link>{{link}}</link><description>{{description}}</description>{{# items }}<item><title>{{title}}</title><link>{{link}}</link><description>{{description}}</description></item>{{/ items}}</channel>{{/ channels }}</rss>'.

	publisher := FOPublisher new
		baseUri: 'https://norbert.hartl.name';
		sourcePath: (tempDir / 'source') fullName;
		outputPath: (tempDir / 'docs') fullName;
		templatePath: 'templates';
		blogs: { #blog -> 'norbert.hartl.name' };
		yourself
]

{ #category : #running }
FOSiteIntegrationTest >> tearDown [
	tempDir ifNotNil: [ tempDir exists ifTrue: [ tempDir deleteAll ] ].
	super tearDown
]

{ #category : #tests }
FOSiteIntegrationTest >> testAboutPagePublishesWithRealFrontmatterQuirk [
	| html |
	publisher publish.
	self assert: (tempDir / 'docs' / 'about.html') exists.
	html := (tempDir / 'docs' / 'about.html') contents.
	self assert: (html includesSubstring: '<title>About me</title>').
	self assert: (html includesSubstring: '<h1>Hey!</h1>').
	self assert: (html includesSubstring: '<a href="http://pharo.org">pharo</a>').
	self assert: (html includesSubstring: 'href="/about.html">about</a>')
]

{ #category : #tests }
FOSiteIntegrationTest >> testBothBlogPostsPublishWithCorrectRenderedMarkdown [
	| picking byob |
	publisher publish.
	self assert: (tempDir / 'docs' / 'blog' / '2022-12-03_picking-it-up.html') exists.
	self assert: (tempDir / 'docs' / 'blog' / 'byob-build-your-own-database.html') exists.
	picking := (tempDir / 'docs' / 'blog' / '2022-12-03_picking-it-up.html') contents.
	byob := (tempDir / 'docs' / 'blog' / 'byob-build-your-own-database.html') contents.
	self assert: (picking includesSubstring: '<h1>Picking it up</h1>').
	self assert: (picking includesSubstring: '<p>What happened so far?').
	self assert: (byob includesSubstring: '<li>an object is the combination of <strong>state and behavior</strong></li>').
	self assert: (byob includesSubstring: '<a href="https://github.com/ApptiveGrid/Soil">Soil</a>')
]

{ #category : #tests }
FOSiteIntegrationTest >> testBlogOverviewContainsBothAbstractsNewestFirst [
	| html pickingIndex byobIndex |
	publisher publish.
	self assert: (tempDir / 'docs' / 'blog' / 'index.html') exists.
	html := (tempDir / 'docs' / 'blog' / 'index.html') contents.
	self assert: (html includesSubstring: 'Picking it up').
	self assert: (html includesSubstring: 'BYOB - build your own (data)base').
	byobIndex := html indexOfSubCollection: 'BYOB'.
	pickingIndex := html indexOfSubCollection: 'Picking it up'.
	self assert: byobIndex < pickingIndex
		description: 'BYOB (2023) should be listed before Picking it up (2022) - newest first'
]

{ #category : #tests }
FOSiteIntegrationTest >> testRssFeedListsBothPostsWithAbsoluteLinks [
	| xml |
	publisher publish.
	self assert: (tempDir / 'docs' / 'blog' / 'rss.xml') exists.
	xml := (tempDir / 'docs' / 'blog' / 'rss.xml') contents.
	self assert: (xml includesSubstring: '<title>norbert.hartl.name</title>').
	self assert: (xml includesSubstring: 'https://norbert.hartl.name/blog/2022-12-03_picking-it-up.html').
	self assert: (xml includesSubstring: 'https://norbert.hartl.name/blog/byob-build-your-own-database.html')
]
