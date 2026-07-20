Class {
	#name : #FOPageWithMetadataTest,
	#superclass : #TestCase,
	#category : #'Foliage-Core-Tests'
}

{ #category : #tests }
FOPageWithMetadataTest >> testIsPage [
	self assert: FOPageWithMetadata new isPage
]

{ #category : #tests }
FOPageWithMetadataTest >> testTitleAndLayoutFromMeta [
	| page |
	page := FOPageWithMetadata new
		meta: (Dictionary new at: #title put: 'Hello'; at: #layout put: 'blog-post'; yourself);
		yourself.
	self assert: page title equals: 'Hello'.
	self assert: page layout equals: 'blog-post'.
	self assert: page hasDocumentType
]

{ #category : #tests }
FOPageWithMetadataTest >> testLayoutFallsBackToParentDefaultLayout [
	| page parent |
	parent := FOWebFolder new.
	page := FOPageWithMetadata new parent: parent; yourself.
	self deny: page hasDocumentType.
	self assert: page layout equals: page defaultLayout
]

{ #category : #tests }
FOPageWithMetadataTest >> testPublishDateParsesFrontmatterStyleValue [
	| page |
	page := FOPageWithMetadata new
		meta: (Dictionary new at: #publishDate put: '2020-09-15'; yourself);
		yourself.
	self assert: page publishDate equals: (Date year: 2020 month: 9 day: 15).
	self assert: page isPublished
]

{ #category : #tests }
FOPageWithMetadataTest >> testEmptyPublishDateIsTreatedAsAbsent [
	| page |
	page := FOPageWithMetadata new
		meta: (Dictionary new at: #publishDate put: ''; yourself);
		yourself.
	self assert: page publishDate isNil.
	self deny: page isPublished
]

{ #category : #tests }
FOPageWithMetadataTest >> testMissingPublishDateIsNil [
	self assert: FOPageWithMetadata new publishDate isNil.
	self deny: FOPageWithMetadata new isPublished
]
