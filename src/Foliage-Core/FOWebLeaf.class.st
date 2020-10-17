Class {
	#name : #FOWebLeaf,
	#superclass : #FOWebItem,
	#instVars : [
		'path'
	],
	#category : #'Foliage-Core'
}

{ #category : #testing }
FOWebLeaf class >> isAbstract [ 
	^ self == FOWebLeaf
]

{ #category : #accessing }
FOWebLeaf >> name [
	^ path segments last
]

{ #category : #accessing }
FOWebLeaf >> path [
	^ path
]

{ #category : #accessing }
FOWebLeaf >> path: anObject [
	path := anObject
]

{ #category : #printing }
FOWebLeaf >> printOn: aStream [ 
	aStream << 'leaf: ' << path asString 
]

{ #category : #accessing }
FOWebLeaf >> rawPath [ 
	^ self website rawPath resolve: path
]
