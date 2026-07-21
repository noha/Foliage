Class {
	#name : #FOCountingTestFolder,
	#superclass : #FOWebFolder,
	#instVars : [
		'createOnTargetCallCount'
	],
	#category : #'Foliage-Core-Tests'
}

{ #category : #actions }
FOCountingTestFolder >> createOnTarget [
	createOnTargetCallCount := self createOnTargetCallCount + 1.
	super createOnTarget
]

{ #category : #accessing }
FOCountingTestFolder >> createOnTargetCallCount [
	^ createOnTargetCallCount ifNil: [ 0 ]
]
