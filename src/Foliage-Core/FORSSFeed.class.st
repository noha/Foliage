Class {
	#name : #FORSSFeed,
	#superclass : #FOWebResource,
	#instVars : [
		'channels'
	],
	#category : #'Foliage-Core-RSS'
}

{ #category : #visiting }
FORSSFeed >> acceptFOVisitor: aFOVisitor [
	^ aFOVisitor visitRSSFeed: self
]

{ #category : #adding }
FORSSFeed >> addChannel: aFORSSChannel [
	self channels add: aFORSSChannel
]

{ #category : #actions }
FORSSFeed >> addHeadersTo: aPage [
	"Injects a <link rel=alternate ...> for this feed into aPage's <head>,
	via Soup DOM manipulation (kept per the explicit decision to retain
	post-hoc HTML post-processing rather than go template-only)."
	| htmlDocument head |
	htmlDocument := aPage htmlDocument.
	head := (htmlDocument / #html / #head) first.
	head addChild: ((SoupTag named: #link)
		attributeAt: #rel put: self rel;
		attributeAt: #href put: self href printString;
		attributeAt: #type put: self linkType;
		attributeAt: #title put: self title;
		beSelfClosing;
		yourself)
]

{ #category : #accessing }
FORSSFeed >> channels [
	^ channels ifNil: [ channels := OrderedCollection new ]
]

{ #category : #accessing }
FORSSFeed >> href [
	^ self absoluteLink
]

{ #category : #accessing }
FORSSFeed >> linkType [
	^ 'application/rss+xml'
]

{ #category : #accessing }
FORSSFeed >> pathString [
	"Overridden: the base FOWebResource>>pathString forces a .html extension,
	which would clobber the .xml this feed's key already has (fed in as
	#'rss.xml' when placed into a folder)."
	^ (self path withExtension: #xml) pathString
]

{ #category : #accessing }
FORSSFeed >> rel [
	^ #alternate
]

{ #category : #accessing }
FORSSFeed >> title [
	^ 'blog'
]
