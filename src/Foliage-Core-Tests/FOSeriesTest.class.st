Class {
	#name : #FOSeriesTest,
	#superclass : #TestCase,
	#category : #'Foliage-Core-Tests'
}

{ #category : #tests }
FOSeriesTest >> testTitleFromSlugCapitalizesEachHyphenatedWord [
	self assert: (FOSeries titleFromSlug: 'soil') equals: 'Soil'.
	self assert: (FOSeries titleFromSlug: 'byob-database') equals: 'Byob Database'
]

{ #category : #tests }
FOSeriesTest >> testTitleFromSlugHandlesSingleLetterWords [
	self assert: (FOSeries titleFromSlug: 'a-b') equals: 'A B'
]

{ #category : #tests }
FOSeriesTest >> testTitleDelegatesToClassSideTitleFromSlug [
	| series |
	series := FOSeries new slug: 'soil'; yourself.
	self assert: series title equals: 'Soil'
]
