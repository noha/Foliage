Class {
	#name : #FOHTMLPage,
	#superclass : #FOFileBasedWebEntity,
	#instVars : [
		'htmlDocument',
		'htmlString'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #testing }
FOHTMLPage class >> supportedFileExtensions [
	^ #( html )
]

{ #category : #visiting }
FOHTMLPage >> acceptFOVisitor: aFOVisitor [
	^ aFOVisitor visitHTMLPageSource: self
]

{ #category : #converting }
FOHTMLPage >> asFOBlogPost [
	^ self as: FOBlogPost
]

{ #category : #accessing }
FOHTMLPage >> buildHtmlDocument [
	"Parses the rendered HTML string back into a DOM via Soup, e.g. so a
	visitor can later inject a header into <head> (RSS <link>, etc.)."
	| document |
	document := Soup fromString: self htmlString utf8Encoded asString.
	htmlString := nil.
	^ document
]

{ #category : #accessing }
FOHTMLPage >> buildHtmlString [
	htmlDocument ifNotNil: [ ^ htmlDocument printString ].
	^ self render
]

{ #category : #accessing }
FOHTMLPage >> htmlDocument [
	^ htmlDocument ifNil: [ htmlDocument := self buildHtmlDocument ]
]

{ #category : #accessing }
FOHTMLPage >> htmlString [
	^ htmlString ifNil: [ htmlString := self buildHtmlString ]
]

{ #category : #accessing }
FOHTMLPage >> htmlString: aString [
	htmlString := aString
]

{ #category : #'instance creation' }
FOHTMLPage >> newRenderContext [
	^ super newRenderContext
		page: self
]

{ #category : #rendering }
FOHTMLPage >> render [
	^ nil
]

{ #category : #'instance creation' }
FOHTMLPage >> renderContextClass [
	^ FOPageRenderContext
]
