Class {
	#name : #FOHTMLPage,
	#superclass : #FOTextEntity,
	#instVars : [
		'htmlDocument',
		'htmlString'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #accessing }
FOHTMLPage class >> supportedFileExtensions [
	^ #( html )
]

{ #category : #visiting }
FOHTMLPage >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitHTMLPageSource: self 
]

{ #category : #accessing }
FOHTMLPage >> buildHtmlDocument [
	| document |
	document := Soup fromString: self htmlString.
	htmlString := nil.
	^ document
]

{ #category : #'as yet unclassified' }
FOHTMLPage >> buildHtmlString [
	htmlDocument ifNotNil: [ 
		^ htmlDocument printString ].
	^ self render
]

{ #category : #accessing }
FOHTMLPage >> htmlDocument [
	^ htmlDocument ifNil: [ 
		htmlDocument := self buildHtmlDocument ]
]

{ #category : #'as yet unclassified' }
FOHTMLPage >> htmlString [
	^ htmlString ifNil: [ 
		htmlString := self buildHtmlString ]
]
