Class {
	#name : #FOMicroDownPageSource,
	#superclass : #FOPageSource,
	#category : #'Foliage-Core'
}

{ #category : #testing }
FOMicroDownPageSource class >> supportedFileExtensions [
	^ #( md )
]

{ #category : #visiting }
FOMicroDownPageSource >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitMicrodownPageSource: self 
]

{ #category : #'as yet unclassified' }
FOMicroDownPageSource >> gtInspectorContentsIn: composite [
	<gtInspectorPresentationOrder: 5>
	composite text
		title: 'Contents';
		format: #asText;
		display: [ PRRichTextComposer new start: self pillar ]
]

{ #category : #'as yet unclassified' }
FOMicroDownPageSource >> pillar [
	^ self content asPillar 
]

{ #category : #generation }
FOMicroDownPageSource >> readContentFrom: aStream [
 	^ (MicroDownParser parse: aStream upToEnd). 

]

{ #category : #rendering }
FOMicroDownPageSource >> renderOn: aStream [ 
	FOPillarHTMLVisitor new
		stream: aStream;
		start: self pillar.
		
]
