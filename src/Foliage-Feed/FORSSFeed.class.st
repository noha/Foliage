Class {
	#name : #FORSSFeed,
	#superclass : #FOWebResource,
	#instVars : [
		'channels'
	],
	#category : #'Foliage-Feed'
}

{ #category : #visiting }
FORSSFeed >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitBlog: self 
]

{ #category : #adding }
FORSSFeed >> addChannel: aFORSSChannel [ 
	self channels add: aFORSSChannel 
]

{ #category : #accessing }
FORSSFeed >> channels [
	^ channels ifNil: [ 
		channels := OrderedCollection new ]
]

{ #category : #'as yet unclassified' }
FORSSFeed >> href [
	^ self absoluteLink 
]

{ #category : #'as yet unclassified' }
FORSSFeed >> linkType [
	^ 'application/rss+xml'
]

{ #category : #accessing }
FORSSFeed >> pathString [
	^ (self path withExtension: #xml) pathString
]

{ #category : #'as yet unclassified' }
FORSSFeed >> rel [
	^ #alternate
]

{ #category : #accessing }
FORSSFeed >> title [
	^ 'blog'
]
