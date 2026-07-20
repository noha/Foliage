Class {
	#name : #FOLineClassifierTest,
	#superclass : #TestCase,
	#category : #'Foliage-Markdown-Tests'
}

{ #category : #tests }
FOLineClassifierTest >> testBlank [
	| c |
	c := FOLineClassifier classify: '   '.
	self assert: c kind equals: #blank
]

{ #category : #tests }
FOLineClassifierTest >> testAtxHeaderLevel1 [
	| c |
	c := FOLineClassifier classify: '# H1 header'.
	self assert: c kind equals: #atxHeader.
	self assert: c level equals: 1
]

{ #category : #tests }
FOLineClassifierTest >> testAtxHeaderLevel4 [
	| c |
	c := FOLineClassifier classify: '#### H4 header'.
	self assert: c kind equals: #atxHeader.
	self assert: c level equals: 4
]

{ #category : #tests }
FOLineClassifierTest >> testFenceWithLanguage [
	| c |
	c := FOLineClassifier classify: '```language=smalltalk'.
	self assert: c kind equals: #fenceDelimiter.
	self assert: c language equals: 'smalltalk'
]

{ #category : #tests }
FOLineClassifierTest >> testFenceWithoutLanguage [
	| c |
	c := FOLineClassifier classify: '```'.
	self assert: c kind equals: #fenceDelimiter.
	self assert: c language isNil
]

{ #category : #tests }
FOLineClassifierTest >> testFenceLenientWithFourBackticks [
	| c |
	c := FOLineClassifier classify: '````language=html'.
	self assert: c kind equals: #fenceDelimiter.
	self assert: c language equals: 'html'
]

{ #category : #tests }
FOLineClassifierTest >> testBlockquote [
	| c |
	c := FOLineClassifier classify: '> This is a quote'.
	self assert: c kind equals: #blockquote
]

{ #category : #tests }
FOLineClassifierTest >> testUnorderedListItem [
	| c |
	c := FOLineClassifier classify: '- A'.
	self assert: c kind equals: #unorderedListItem.
	self assert: c ordered equals: false.
	self assert: c contentColumn equals: 2
]

{ #category : #tests }
FOLineClassifierTest >> testOrderedListItem [
	| c |
	c := FOLineClassifier classify: '1. first'.
	self assert: c kind equals: #orderedListItem.
	self assert: c ordered equals: true.
	self assert: c contentColumn equals: 3
]

{ #category : #tests }
FOLineClassifierTest >> testOrderedListItemMultiDigit [
	| c |
	c := FOLineClassifier classify: '12. twelfth'.
	self assert: c kind equals: #orderedListItem.
	self assert: c contentColumn equals: 4
]

{ #category : #tests }
FOLineClassifierTest >> testNestedOrderedListItemTracksIndent [
	| c |
	c := FOLineClassifier classify: '  1. first'.
	self assert: c kind equals: #orderedListItem.
	self assert: c indent equals: 2.
	self assert: c contentColumn equals: 5
]

{ #category : #tests }
FOLineClassifierTest >> testImageLineWithAttributes [
	| c |
	c := FOLineClassifier classify: '![Foliage](/images/foliage-banner.jpg class=u-full-width)'.
	self assert: c kind equals: #imageLine.
	self assert: c alt equals: 'Foliage'.
	self assert: c src equals: '/images/foliage-banner.jpg'.
	self assert: (c attributes at: #class) equals: 'u-full-width'
]

{ #category : #tests }
FOLineClassifierTest >> testImageLineWithoutAttributes [
	| c |
	c := FOLineClassifier classify: '![alt text](/images/IMG_9474.jpeg)'.
	self assert: c kind equals: #imageLine.
	self assert: c alt equals: 'alt text'.
	self assert: c src equals: '/images/IMG_9474.jpeg'.
	self assert: c attributes isEmpty
]

{ #category : #tests }
FOLineClassifierTest >> testIndentedCode [
	| c |
	c := FOLineClassifier classify: '    fun no fun'.
	self assert: c kind equals: #indentedCode.
	self assert: c indent equals: 4
]

{ #category : #tests }
FOLineClassifierTest >> testParagraphText [
	| c |
	c := FOLineClassifier classify: 'Lorem ipsum dolor sit amet.'.
	self assert: c kind equals: #paragraphText
]
