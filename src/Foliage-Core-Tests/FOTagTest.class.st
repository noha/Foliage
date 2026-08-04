Class {
	#name : #FOTagTest,
	#superclass : #TestCase,
	#category : #'Foliage-Core-Tests'
}

{ #category : #tests }
FOTagTest >> testTitleFromSlugCapitalizesEachHyphenatedWord [
	self assert: (FOTag titleFromSlug: 'soil') equals: 'Soil'.
	self assert: (FOTag titleFromSlug: 'byob-database') equals: 'Byob Database'
]

{ #category : #tests }
FOTagTest >> testTitleFromSlugHandlesSingleLetterWords [
	self assert: (FOTag titleFromSlug: 'a-b') equals: 'A B'
]

{ #category : #tests }
FOTagTest >> testTitleDelegatesToClassSideTitleFromSlug [
	| tag |
	tag := FOTag new slug: 'soil'; yourself.
	self assert: tag title equals: 'Soil'
]

{ #category : #tests }
FOTagTest >> testPostCountIsPostsSize [
	| tag |
	tag := FOTag new posts: #(1 2 3); yourself.
	self assert: tag postCount equals: 3
]
