Class {
	#name : #FOTestWebsite,
	#superclass : #Object,
	#instVars : [
		'targetPath',
		'rawPath',
		'root',
		'templatePath'
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

{ #category : #accessing }
FOTestWebsite >> templatePath [
	^ templatePath
]

{ #category : #accessing }
FOTestWebsite >> templatePath: aFileReference [
	templatePath := aFileReference
]

{ #category : #accessing }
FOTestWebsite >> templatePathForLayout: aString [
	^ self templatePath / aString
]

{ #category : #accessing }
FOTestWebsite >> templatePathForLayout: aString partial: partialName [
	^ self templatePath / partialName
]
