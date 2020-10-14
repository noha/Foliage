Class {
	#name : #FOPage,
	#superclass : #Object,
	#instVars : [
		'meta',
		'content'
	],
	#category : #'Foliage-Core'
}

{ #category : #accessing }
FOPage >> content: aMicRootBlock [ 
	content := aMicRootBlock 
]

{ #category : #'as yet unclassified' }
FOPage >> gtInspectorContentsIn: composite [
	<gtInspectorPresentationOrder: 5>
	composite text
		title: 'Contents';
		format: #asText;
		display: [ PRRichTextComposer new start: self pillar ]
]

{ #category : #testing }
FOPage >> hasDocumentType [
	^ meta includesKey: 'layout'
]

{ #category : #accessing }
FOPage >> layout [
	^ meta at: 'layout'
]

{ #category : #accessing }
FOPage >> meta: aCollection [ 
	meta := aCollection 
]

{ #category : #'as yet unclassified' }
FOPage >> pillar [
	^ content asPillar 
]
