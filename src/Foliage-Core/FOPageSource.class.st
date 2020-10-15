Class {
	#name : #FOPageSource,
	#superclass : #Object,
	#instVars : [
		'meta',
		'content',
		'path'
	],
	#category : #'Foliage-Core'
}

{ #category : #accessing }
FOPageSource >> content: aMicRootBlock [ 
	content := aMicRootBlock 
]

{ #category : #'as yet unclassified' }
FOPageSource >> gtInspectorContentsIn: composite [
	<gtInspectorPresentationOrder: 5>
	composite text
		title: 'Contents';
		format: #asText;
		display: [ PRRichTextComposer new start: self pillar ]
]

{ #category : #testing }
FOPageSource >> hasDocumentType [
	^ meta includesKey: 'layout'
]

{ #category : #accessing }
FOPageSource >> layout [
	^ meta at: 'layout'
]

{ #category : #accessing }
FOPageSource >> meta: aCollection [ 
	meta := aCollection 
]

{ #category : #accessing }
FOPageSource >> path [
	^ path
]

{ #category : #accessing }
FOPageSource >> path: anObject [
	path := anObject
]

{ #category : #'as yet unclassified' }
FOPageSource >> pillar [
	^ content asPillar 
]

{ #category : #accessing }
FOPageSource >> validate [ 
	self hasDocumentType ifFalse: [ 
		Error signal: 'document in ', path asString, ' is missing type' ].
]
