Class {
	#name : #FOPillarPage,
	#superclass : #FOPageWithMetadata,
	#instVars : [
		'document'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #testing }
FOPillarPage class >> supportedFileExtensions [
	^ { } 
]

{ #category : #'as yet unclassified' }
FOPillarPage >> abstract [
	| abstract |
	abstract := (Character space join: (document children allButFirst collect: #text)).
	^ abstract first: (abstract size min: 400)
]

{ #category : #visiting }
FOPillarPage >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitPillarPage: self 
]

{ #category : #accessing }
FOPillarPage >> document [
	^ document
]

{ #category : #accessing }
FOPillarPage >> document: aMicRootBlock [ 
	document := aMicRootBlock
]

{ #category : #accessing }
FOPillarPage >> pillar: aPRDocument [ 
	document := aPRDocument 
]

{ #category : #actions }
FOPillarPage >> publish [
	self publishPath writeStream
		truncate;
		nextPutAll: self htmlString;
		flush; 
		close.
]

{ #category : #'as yet unclassified' }
FOPillarPage >> publishPathFor: aString [ 
	^ (aString endsWith: #html)
		ifTrue: [ aString ]
		ifFalse: [ (aString allButLast: 2), #html ]
]

{ #category : #rendering }
FOPillarPage >> render [ 
	^ self newRenderContext renderTemplate: self template.
]

{ #category : #rendering }
FOPillarPage >> renderOn: aStream [ 
	FOPillarHTMLVisitor new
		stream: aStream;
		start: document.
]

{ #category : #'as yet unclassified' }
FOPillarPage >> template [
	^ (self website templatePathForLayout: self layout) asMustacheTemplate.
]
