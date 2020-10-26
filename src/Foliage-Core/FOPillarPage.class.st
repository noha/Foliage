Class {
	#name : #FOPillarPage,
	#superclass : #FOPageSource,
	#instVars : [
		'document'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #testing }
FOPillarPage class >> supportedFileExtensions [
	^ { } 
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

{ #category : #rendering }
FOPillarPage >> renderOn: aStream [ 
	FOPillarHTMLVisitor new
		stream: aStream;
		start: document.
]
