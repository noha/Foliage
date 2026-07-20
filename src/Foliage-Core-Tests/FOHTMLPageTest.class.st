Class {
	#name : #FOHTMLPageTest,
	#superclass : #TestCase,
	#category : #'Foliage-Core-Tests'
}

{ #category : #tests }
FOHTMLPageTest >> testHtmlStringSetDirectlyIsReturnedAsIs [
	| page |
	page := FOHTMLPage new.
	page htmlString: '<p>Hi</p>'.
	self assert: page htmlString equals: '<p>Hi</p>'
]

{ #category : #tests }
FOHTMLPageTest >> testHtmlDocumentIsBuiltFromHtmlString [
	| page |
	page := FOHTMLPage new.
	page htmlString: '<html><head></head><body><p>Hi</p></body></html>'.
	self assert: (page htmlDocument / #html / #body / #p) first text equals: 'Hi'
]

{ #category : #tests }
FOHTMLPageTest >> testHtmlStringIsRebuiltFromHtmlDocumentAfterAccessingIt [
	| page |
	page := FOHTMLPage new.
	page htmlString: '<html><head></head><body><p>Hi</p></body></html>'.
	page htmlDocument.
	self assert: page htmlString equals: page htmlDocument printString
]

{ #category : #tests }
FOHTMLPageTest >> testRenderReturnsNilByDefault [
	self assert: FOHTMLPage new render isNil
]

{ #category : #tests }
FOHTMLPageTest >> testHtmlStringFallsBackToRenderWhenNothingIsSet [
	self assert: FOHTMLPage new htmlString isNil
]
