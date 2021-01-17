Class {
	#name : #FOMetaParserTest,
	#superclass : #TestCase,
	#category : #'Foliage-Core-Tests'
}

{ #category : #parsing }
FOMetaParserTest >> parse: aString [ 
	^ FOMetaReader parse: aString
]

{ #category : #tests }
FOMetaParserTest >> testMetaPlusContent [
	| props |
	props := self parse: 'title: A blog entry
foo: bar

Some html maybe'.
	self assert: props size = 2.
	self assert: (props at: 'title') equals: 'A blog entry'.
	self assert: (props at: 'foo') equals: 'bar'
]

{ #category : #tests }
FOMetaParserTest >> testMultipleLinesKeyValue [
	| props |
	props := self parse: 'title: A blog entry
foo: bar'.
	self assert: props size = 2.
	self assert: (props at: 'title') equals: 'A blog entry'.
	self assert: (props at: 'foo') equals: 'bar'
]

{ #category : #tests }
FOMetaParserTest >> testOneLineKeyArray [
	| props |
	props := self parse: 'title: one ; two; three  '.
	self assert: props size = 1.
	self assert: (props at: 'title') equals: #( one two three ) asOrderedCollection 
]

{ #category : #tests }
FOMetaParserTest >> testOneLineKeyValue [
	| props |
	props := self parse: 'title: A blog entry'.
	self assert: props size = 1.
	self assert: (props at: 'title') equals: 'A blog entry'
]

{ #category : #tests }
FOMetaParserTest >> testOneLineKeyValueWithKeySpaces [
	| props |
	props := self parse: ' title :  A blog entry   '.
	self assert: props size = 1.
	self assert: (props at: 'title') equals: 'A blog entry'
]
