Class {
	#name : #FOFrontmatter,
	#superclass : #Object,
	#instVars : [
		'properties',
		'body'
	],
	#category : #'Foliage-Frontmatter'
}

{ #category : #'instance creation' }
FOFrontmatter class >> properties: aDictionary body: aString [
	^ self new
		setProperties: aDictionary body: aString;
		yourself
]

{ #category : #accessing }
FOFrontmatter >> properties [
	^ properties
]

{ #category : #accessing }
FOFrontmatter >> body [
	^ body
]

{ #category : #accessing }
FOFrontmatter >> at: aKey [
	^ properties at: aKey
]

{ #category : #accessing }
FOFrontmatter >> at: aKey ifAbsent: aBlock [
	^ properties at: aKey ifAbsent: aBlock
]

{ #category : #private }
FOFrontmatter >> setProperties: aDictionary body: aString [
	properties := aDictionary.
	body := aString
]
