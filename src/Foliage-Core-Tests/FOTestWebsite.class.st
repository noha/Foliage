Class {
	#name : #FOTestWebsite,
	#superclass : #Object,
	#instVars : [
		'targetPath',
		'rawPath',
		'root'
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

{ #category : #accessing }
FOTestWebsite >> rawPath [
	^ rawPath
]

{ #category : #accessing }
FOTestWebsite >> rawPath: aFileReference [
	rawPath := aFileReference
]

{ #category : #accessing }
FOTestWebsite >> root [
	^ root
]

{ #category : #accessing }
FOTestWebsite >> root: aFOWebsiteRoot [
	root := aFOWebsiteRoot
]

{ #category : #navigating }
FOTestWebsite >> resolvePath: aPath [
	^ root resolvePath: aPath
]

{ #category : #accessing }
FOTestWebsite >> relativeRawPath: aFileReference [
	^ aFileReference asAbsolute relativeTo: self rawPath asAbsolute
]
