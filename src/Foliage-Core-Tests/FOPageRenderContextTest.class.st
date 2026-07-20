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
FOPageRenderContextTest >> testPublishDateDelegatesToPage [
	"Confirms the publicationDate/publishDate name-mismatch bug from the old
	FOPageRenderContext is fixed - this must actually resolve, not DNU."
	| context |
	context := FOPageRenderContext new page: self makePage; yourself.
	self assert: context publishDate equals: (Date year: 2020 month: 9 day: 15)
]
