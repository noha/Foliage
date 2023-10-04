Class {
	#name : #FOHTMLPage,
	#superclass : #FOFileBasedWebEntity,
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

{ #category : #converting }
FOHTMLPage >> asFOBlogPost [
	^ self as: FOBlogPost
]

{ #category : #accessing }
FOHTMLPage >> buildHtmlDocument [
	| document |
	document := Soup fromString: self htmlString utf8Encoded asString.
	htmlString := nil.
	^ document
]

{ #category : #converting }
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

{ #category : #accessing }
FOHTMLPage >> htmlString [
	^ htmlString ifNil: [ 
		htmlString := self buildHtmlString ]
]

{ #category : #'instance creation' }
FOHTMLPage >> newRenderContext [ 
	^ super newRenderContext 
		page: self 
]

{ #category : #converting }
FOHTMLPage >> render [

	^ nil
]

{ #category : #'instance creation' }
FOHTMLPage >> renderContextClass [

	^ FOPageRenderContext
]
