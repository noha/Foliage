Class {
	#name : #FOTagRenderContext,
	#superclass : #FORenderContext,
	#instVars : [
		'tag'
	],
	#category : #'Foliage-Core-Blog'
}

{ #category : #accessing }
FOTagRenderContext >> abstract [
	^ tag abstract
]

{ #category : #accessing }
FOTagRenderContext >> layout [
	^ tag abstractLayout
]

{ #category : #accessing }
FOTagRenderContext >> postCount [
	^ tag postCount
]

{ #category : #accessing }
FOTagRenderContext >> pathString [
	^ tag pathString
]

{ #category : #accessing }
FOTagRenderContext >> tag [
	^ tag
]

{ #category : #accessing }
FOTagRenderContext >> tag: aFOTag [
	tag := aFOTag
]

{ #category : #accessing }
FOTagRenderContext >> title [
	^ tag title
]
