Class {
	#name : #FOPillarPage,
	#superclass : #FOPageSource,
	#instVars : [
		'document',
		'links'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #testing }
FOPillarPage class >> supportedFileExtensions [
	^ { } 
]

{ #category : #'as yet unclassified' }
FOPillarPage >> abstract [
	^ (Character space join: (document children allButFirst collect: #text)) first: 400
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
FOPillarPage >> links [ 
	^ links ifNil: [ 
		links := OrderedCollection new ]
]

{ #category : #accessing }
FOPillarPage >> pillar: aPRDocument [ 
	document := aPRDocument 
]

{ #category : #rendering }
FOPillarPage >> renderOn: aStream [ 
	FOPillarHTMLVisitor new
		stream: aStream;
		start: document.
]
