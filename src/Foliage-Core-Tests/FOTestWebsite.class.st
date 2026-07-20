Class {
	#name : #FOTestWebsite,
	#superclass : #Object,
	#instVars : [
		'targetPath'
	],
	#category : #'Foliage-Core-Tests'
}

{ #category : #accessing }
FOTestWebsite >> targetPath [
	^ targetPath
]

{ #category : #accessing }
FOTestWebsite >> targetPath: aFileReference [
	targetPath := aFileReference
]
