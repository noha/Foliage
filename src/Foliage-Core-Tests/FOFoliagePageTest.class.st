Class {
	#name : #FOFoliagePageTest,
	#superclass : #TestCase,
	#category : #'Foliage-Core-Tests'
}

{ #category : #tests }
FOFoliagePageTest >> testRenderOnUsesHTMLRenderVisitor [
	| page stream |
	page := FOFoliagePage new
		document: (FOMarkdownParser parse: '# Title', (String with: Character lf), (String with: Character lf), 'Body text.');
		yourself.
	stream := WriteStream on: String new.
	page renderOn: stream.
	self assert: stream contents equals: '<h1>Title</h1>', (String with: Character lf), '<p>Body text.</p>'
]

{ #category : #tests }
FOFoliagePageTest >> testPublishPathAlwaysHasHtmlExtension [
	| page website root |
	website := FOTestWebsite new targetPath: 'docs' asFileReference; yourself.
	root := FOWebsiteRoot new parent: website; yourself.
	page := FOFoliagePage new.
	root at: #'my-post' put: page.
	self assert: page publishPath asString equals: 'docs/my-post.html' asFileReference asString
]

{ #category : #tests }
FOFoliagePageTest >> testRenderProducesFullTemplatedPageThroughMustache [
	| templateDir website root page html |
	templateDir := FileLocator temp / ('fo-foliage-page-test-', UUID new asString36).
	templateDir ensureCreateDirectory.
	[
		(templateDir / 'blog-post') writeStreamDo: [ :s |
			s nextPutAll: '<html><head><title>{{page.title}}</title></head><body>{{> page-header}}<div>{{{ body }}}</div></body></html>' ].
		(templateDir / 'page-header') writeStreamDo: [ :s | s nextPutAll: '<header>Site</header>' ].

		website := FOTestWebsite new templatePath: templateDir; yourself.
		root := FOWebsiteRoot new parent: website; yourself.
		page := FOFoliagePage new
			meta: (Dictionary new at: #title put: 'Hi'; at: #layout put: 'blog-post'; yourself);
			document: (FOMarkdownParser parse: 'Body text.');
			yourself.
		root at: #'my-post' put: page.

		html := page render.
		self assert: html equals: '<html><head><title>Hi</title></head><body><header>Site</header><div><p>Body text.</p></div></body></html>'
	] ensure: [ templateDir deleteAll ]
]
