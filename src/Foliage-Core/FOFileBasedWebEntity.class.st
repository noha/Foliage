Class {
	#name : #FOFileBasedWebEntity,
	#superclass : #FOWebResource,
	#instVars : [
		'sourcePath'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #testing }
FOFileBasedWebEntity class >> isAbstract [ 
	^ self == FOFileBasedWebEntity
]

{ #category : #accessing }
FOFileBasedWebEntity >> name [
	^ parent nameOf: self
]

{ #category : #accessing }
FOFileBasedWebEntity >> sourcePath [
	^ sourcePath
]

{ #category : #accessing }
FOFileBasedWebEntity >> sourcePath: anObject [
	sourcePath := anObject
]
