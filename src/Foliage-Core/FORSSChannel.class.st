Class {
	#name : #FORSSChannel,
	#superclass : #Object,
	#instVars : [
		'items',
		'title',
		'link',
		'description'
	],
	#category : #'Foliage-Core-RSS'
}

{ #category : #accessing }
FORSSChannel >> description [
	^ description
]

{ #category : #accessing }
FORSSChannel >> description: anObject [
	description := anObject
]

{ #category : #accessing }
FORSSChannel >> items [
	^ items
]

{ #category : #accessing }
FORSSChannel >> items: aCollection [ 
	items := aCollection 
]

{ #category : #accessing }
FORSSChannel >> link [
	^ link
]

{ #category : #accessing }
FORSSChannel >> link: aString [ 
	link := aString
]

{ #category : #accessing }
FORSSChannel >> title [
	^ title
]

{ #category : #accessing }
FORSSChannel >> title: aString [ 
	title := aString
]
