Class {
	#name : #FOSkeletonThemeTest,
	#superclass : #TestCase,
	#category : #'Foliage-Core-Tests'
}

{ #category : #tests }
FOSkeletonThemeTest >> testArchiveName [
	self assert: FOSkeletonTheme new archiveName equals: 'Skeleton-2.0.4.zip'
]

{ #category : #tests }
FOSkeletonThemeTest >> testPageTemplateReferencesExpectedMustachePlaceholders [
	| template |
	template := FOSkeletonTheme new pageTemplate.
	self assert: (template includesSubstring: '{{page.title}}').
	self assert: (template includesSubstring: '{{{ body }}}').
	self assert: (template includesSubstring: '/css/normalize.css').
	self assert: (template includesSubstring: '/css/skeleton.css')
]

{ #category : #tests }
FOSkeletonThemeTest >> testIsAFOTheme [
	self assert: (FOSkeletonTheme new isKindOf: FOTheme)
]
