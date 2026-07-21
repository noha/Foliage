Class {
	#name : #FOFoliagePage,
	#superclass : #FOPageWithMetadata,
	#instVars : [
		'document',
		'bodyHtml'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #visiting }
FOFoliagePage >> acceptFOVisitor: aFOVisitor [
	^ aFOVisitor visitFoliagePage: self
]

{ #category : #accessing }
FOFoliagePage >> bodyHtml: aString [
	"Lets a caller (the blog overview page builder) supply already-rendered
	body content directly instead of a parsed FODocument - #renderOn: uses it
	verbatim when set. Unlike bypassing #render/#template entirely, this still
	goes through the normal templating pipeline (outer layout, {{page.title}},
	partials, ...) - only the *body* is precomputed, not the whole page."
	bodyHtml := aString
]

{ #category : #accessing }
FOFoliagePage >> document [
	^ document
]

{ #category : #accessing }
FOFoliagePage >> document: aFODocument [
	document := aFODocument
]

{ #category : #actions }
FOFoliagePage >> publish [
	self publishPath
		ensureDelete;
		writeStreamDo: [ :stream | stream << self htmlString ]
]

{ #category : #accessing }
FOFoliagePage >> publishPath [
	^ super publishPath withExtension: 'html'
]

{ #category : #rendering }
FOFoliagePage >> render [
	^ self newRenderContext renderTemplate: self template
]

{ #category : #rendering }
FOFoliagePage >> renderOn: aStream [
	aStream nextPutAll: (bodyHtml ifNil: [ FOHTMLRenderVisitor render: self document ] ifNotNil: [ bodyHtml ])
]

{ #category : #accessing }
FOFoliagePage >> template [
	^ (self website templatePathForLayout: self layout) asMustacheTemplate
]
