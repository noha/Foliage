Class {
	#name : #FOFileBasedWebEntity,
	#superclass : #FOWebResource,
	#instVars : [
		'sourcePath'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #accessing }
FOFileBasedWebEntity >> sourcePath [
	^ sourcePath
]

{ #category : #accessing }
FOFileBasedWebEntity >> sourcePath: anObject [
	sourcePath := anObject
]
