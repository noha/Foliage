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
