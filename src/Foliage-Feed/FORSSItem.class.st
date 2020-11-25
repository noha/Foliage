Class {
	#name : #FORSSItem,
	#superclass : #Object,
	#instVars : [
		'title',
		'link',
		'description'
	],
	#category : #'Foliage-Feed'
}

{ #category : #accessing }
FORSSItem >> description [
	^ description
]

{ #category : #accessing }
FORSSItem >> description: aString [ 
	description := aString 
]

{ #category : #accessing }
FORSSItem >> link [
	^ link
]

{ #category : #accessing }
FORSSItem >> link: aLink [
	link := aLink
]

{ #category : #accessing }
FORSSItem >> title [
	^ title
]

{ #category : #accessing }
FORSSItem >> title: aString [ 
	title := aString
]
