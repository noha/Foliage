Class {
	#name : #FOWebObject,
	#superclass : #FOWebResource,
	#instVars : [
		'path'
	],
	#category : #'Foliage-Core'
}

{ #category : #testing }
FOWebObject class >> isAbstract [ 
	^ self == FOWebObject
]

{ #category : #accessing }
FOWebObject >> name [
	^ path segments last
]

{ #category : #accessing }
FOWebObject >> path [
	^ path
]

{ #category : #accessing }
FOWebObject >> path: anObject [
	path := anObject
]

{ #category : #printing }
FOWebObject >> printOn: aStream [ 
	aStream << 'leaf: ' << path asString 
]

{ #category : #accessing }
FOWebObject >> rawPath [ 
	^ self website rawPath resolve: path
]
