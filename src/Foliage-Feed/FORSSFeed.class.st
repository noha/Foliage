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

{ #category : #'as yet unclassified' }
FORSSFeed >> addHeaders [
	| indexPage htmlDocument head |
	indexPage := self website root / 'index.html'.
	htmlDocument := indexPage htmlDocument.
	head := (htmlDocument / #html / #head) first.
	head addChild: ((SoupTag named: #link)
		attributeAt: #rel put: self rel;
		attributeAt: #href put: self href printString;
		attributeAt: #type put: self linkType;
		attributeAt: #title put: self title;
		beSelfClosing ;
		yourself )
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
