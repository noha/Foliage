Class {
	#name : #FOHeaderLink,
	#superclass : #Object,
	#instVars : [
		'rel',
		'type',
		'title',
		'href'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #accessing }
FOHeaderLink >> href [
	^ href
]

{ #category : #'as yet unclassified' }
FOHeaderLink >> href: aZnUrl [ 
	href := aZnUrl 
]

{ #category : #accessing }
FOHeaderLink >> rel [
	^ rel
]

{ #category : #'as yet unclassified' }
FOHeaderLink >> rel: aString [ 
	rel := aString 
]

{ #category : #accessing }
FOHeaderLink >> title [
	^ title
]

{ #category : #accessing }
FOHeaderLink >> title: aString [ 
	title := aString
]

{ #category : #accessing }
FOHeaderLink >> type [
	^ type
]

{ #category : #'accessing structure variables' }
FOHeaderLink >> type: aString [ 
	type := aString 
]
