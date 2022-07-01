Class {
	#name : #FOObjectSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'object',
		'slots',
		'selectors'
	],
	#category : #'Foliage-Core-Base'
}

{ #category : #printing }
FOObjectSignal >> initialize [

	super initialize.
	slots := #().
	selectors := #()
]

{ #category : #accessing }
FOObjectSignal >> object [

	^ object
]

{ #category : #accessing }
FOObjectSignal >> object: anObject [

	object := anObject
]

{ #category : #printing }
FOObjectSignal >> printOneLineContentsOn: stream [

	stream << (STON toString: 
		(slots collect: [ :each | each -> (object readSlotNamed: each) ]), 
		(selectors collect: [ :each | each -> (object perform: each) ]))
]

{ #category : #printing }
FOObjectSignal >> printOneLineOn: stream [

	stream
		nextPutAll: self timestamp asString;
		space;
		nextPutAll: object className;
		space.

	self printOneLineContentsOn: stream
]

{ #category : #accessing }
FOObjectSignal >> selectors [

	^ selectors
]

{ #category : #accessing }
FOObjectSignal >> selectors: aCollection [

	selectors := aCollection
]

{ #category : #accessing }
FOObjectSignal >> slots [

	^ slots
]

{ #category : #accessing }
FOObjectSignal >> slots: anObject [

	slots := anObject
]
