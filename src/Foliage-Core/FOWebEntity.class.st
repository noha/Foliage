Class {
	#name : #FOWebEntity,
	#superclass : #FOWebResource,
	#instVars : [
		'sourcePath'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #testing }
FOWebEntity class >> isAbstract [ 
	^ self == FOWebEntity
]

{ #category : #copying }
FOWebEntity >> duplicate [ 
	^ self copy resetParent
]

{ #category : #accessing }
FOWebEntity >> name [
	^ parent nameOf: self
]

{ #category : #accessing }
FOWebEntity >> sourcePath [
	^ sourcePath
]

{ #category : #accessing }
FOWebEntity >> sourcePath: anObject [
	sourcePath := anObject
]
