Class {
	#name : #FOHTMLEntity,
	#superclass : #FOTextEntity,
	#instVars : [
		'htmlDocument',
		'htmlString'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #accessing }
FOHTMLEntity class >> supportedFileExtensions [
	^ #( html )
]

{ #category : #visiting }
FOHTMLEntity >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitHTMLPageSource: self 
]

{ #category : #accessing }
FOHTMLEntity >> buildHtmlDocument [
	| document |
	document := Soup fromString: self htmlString.
	htmlString := nil.
	^ document
]

{ #category : #'as yet unclassified' }
FOHTMLEntity >> buildHtmlString [
	htmlDocument ifNotNil: [ 
		^ htmlDocument printString ].
	^ self render
]

{ #category : #accessing }
FOHTMLEntity >> htmlDocument [
	^ htmlDocument ifNil: [ 
		htmlDocument := self buildHtmlDocument ]
]

{ #category : #'as yet unclassified' }
FOHTMLEntity >> htmlString [
	^ htmlString ifNil: [ 
		htmlString := self buildHtmlString ]
]
