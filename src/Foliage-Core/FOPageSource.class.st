Class {
	#name : #FOPageSource,
	#superclass : #FOWebObject,
	#instVars : [
		'meta',
		'content'
	],
	#category : #'Foliage-Core'
}

{ #category : #testing }
FOPageSource class >> isAbstract [ 
	^ self == FOPageSource  
]

{ #category : #accessing }
FOPageSource >> content [
	^ content ifNil: [ 
		self readContents.
		content ]
]

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

{ #category : #'as yet unclassified' }
FOPageSource >> pillar [
	^ self content asPillar 
]

{ #category : #accessing }
FOPageSource >> readContents [
	self readFrom: (self website rawPath resolve: path) 
]

{ #category : #generation }
FOPageSource >> readFrom: aFileReference [ 
	(FOPageReader new
		readFrom: aFileReference readStream
		page: self).
	self validate
]

{ #category : #accessing }
FOPageSource >> validate [ 
	self hasDocumentType ifFalse: [ 
		Error signal: 'document in ', path asString, ' is missing type' ].
]
