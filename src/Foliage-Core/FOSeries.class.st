Class {
	#name : #FOSeries,
	#superclass : #Object,
	#instVars : [
		'slug',
		'posts'
	],
	#category : #'Foliage-Core-Blog'
}

{ #category : #'instance creation' }
FOSeries class >> titleFromSlug: aSlug [
	"'soil' -> 'Soil', 'byob-database' -> 'Byob Database'. A zero-config
	stand-in for a real display title, per the lean-rollout decision to defer
	a slug->title registry until one is actually needed."
	^ String streamContents: [ :s |
		(aSlug substrings: '-') do: [ :word |
			s nextPutAll: word first asUppercase asString.
			word size > 1 ifTrue: [ s nextPutAll: (word copyFrom: 2 to: word size) ] ]
		separatedBy: [ s nextPut: $  ] ]
]

{ #category : #accessing }
FOSeries >> posts [
	^ posts
]

{ #category : #accessing }
FOSeries >> posts: aCollection [
	posts := aCollection
]

{ #category : #accessing }
FOSeries >> slug [
	^ slug
]

{ #category : #accessing }
FOSeries >> slug: aString [
	slug := aString
]

{ #category : #accessing }
FOSeries >> title [
	^ self class titleFromSlug: slug
]
