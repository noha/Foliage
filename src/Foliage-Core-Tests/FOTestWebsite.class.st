Class {
	#name : #FOTestWebsite,
	#superclass : #Object,
	#instVars : [
		'outputPath',
		'contentPath',
		'root',
		'templatePath',
		'blogPaths'
	],
	#category : #'Foliage-Core-Tests'
}

{ #category : #accessing }
FOTestWebsite >> outputPath [
	^ outputPath
]

{ #category : #accessing }
FOTestWebsite >> outputPath: aFileReference [
	outputPath := aFileReference
]

{ #category : #accessing }
FOTestWebsite >> contentPath [
	^ contentPath
]

{ #category : #accessing }
FOTestWebsite >> contentPath: aFileReference [
	contentPath := aFileReference
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
FOTestWebsite >> relativeContentPath: aFileReference [
	^ aFileReference asAbsolute relativeTo: self contentPath asAbsolute
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

{ #category : #accessing }
FOTestWebsite >> blogPaths [
	^ blogPaths ifNil: [ #() ]
]

{ #category : #accessing }
FOTestWebsite >> blogPaths: aCollection [
	blogPaths := aCollection
]
