Class {
	#name : #FOPageRenderContextTest,
	#superclass : #TestCase,
	#category : #'Foliage-Core-Tests'
}

{ #category : #private }
FOPageRenderContextTest >> makePage [
	^ FOFoliagePage new
		meta: (Dictionary new at: #title put: 'Hi'; at: #layout put: 'blog-post'; at: #publishDate put: '2020-09-15'; yourself);
		document: (FOMarkdownParser parse: 'Body text.');
		yourself
]

{ #category : #tests }
FOPageRenderContextTest >> testTitleDelegatesToPage [
	| context |
	context := FOPageRenderContext new page: self makePage; yourself.
	self assert: context title equals: 'Hi'
]

{ #category : #tests }
FOPageRenderContextTest >> testLayoutDelegatesToPage [
	| context |
	context := FOPageRenderContext new page: self makePage; yourself.
	self assert: context layout equals: 'blog-post'
]

{ #category : #tests }
FOPageRenderContextTest >> testHtmlAndBodyRenderThePageContent [
	| context |
	context := FOPageRenderContext new page: self makePage; yourself.
	self assert: context html equals: '<p>Body text.</p>'.
	self assert: context body equals: context html
]

{ #category : #tests }
FOPageRenderContextTest >> testPublicationDateDelegatesToPagesPublishDate [
	"The old bug: this delegated to `page publicationDate`, which never
	existed (only `page publishDate` did) - DNU the moment any template
	referenced {{publicationDate}}. Fixed by delegating to the right method,
	keeping this method's own name as-is since real templates
	(blog-post-abstract) reference the Mustache key `publicationDate`
	directly."
	| context |
	context := FOPageRenderContext new page: self makePage; yourself.
	self assert: context publicationDate equals: (Date year: 2020 month: 9 day: 15)
]
