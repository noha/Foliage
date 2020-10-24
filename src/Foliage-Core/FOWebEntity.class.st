Class {
	#name : #FOWebEntity,
	#superclass : #FOWebResource,
	#instVars : [
		'path'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #testing }
FOWebEntity class >> isAbstract [ 
	^ self == FOWebEntity
]

{ #category : #accessing }
FOWebEntity >> name [
	^ path segments last
]

{ #category : #accessing }
FOWebEntity >> path [
	^ path
]

{ #category : #accessing }
FOWebEntity >> path: anObject [
	path := anObject
]

{ #category : #printing }
FOWebEntity >> printOn: aStream [ 
	aStream << 'leaf: ' << path asString 
]

{ #category : #accessing }
FOWebEntity >> rawPath [ 
	^ self website rawPath resolve: path
]
