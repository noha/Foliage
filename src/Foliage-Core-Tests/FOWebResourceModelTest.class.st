Class {
	#name : #FOWebResourceModelTest,
	#superclass : #TestCase,
	#instVars : [
		'root',
		'website'
	],
	#category : #'Foliage-Core-Tests'
}

{ #category : #running }
FOWebResourceModelTest >> setUp [
	super setUp.
	website := FOTestWebsite new outputPath: 'docs' asFileReference; yourself.
	root := FOWebsiteRoot new parent: website; yourself
]

{ #category : #tests }
FOWebResourceModelTest >> testWebsiteRootBasics [
	self assert: root isRoot.
	self assert: root name equals: #/.
	self assert: root path pathString equals: '/'.
	self assert: root website equals: website
]

{ #category : #tests }
FOWebResourceModelTest >> testAtPutSetsNameAndParent [
	| child |
	child := FOWebFolder new.
	root at: #blog put: child.
	self assert: child name equals: #blog.
	self assert: child parent equals: root
]

{ #category : #tests }
FOWebResourceModelTest >> testAtPutRejectsDuplicateKey [
	root at: #blog put: FOWebFolder new.
	self should: [ root at: #blog put: FOWebFolder new ] raise: Error
]

{ #category : #tests }
FOWebResourceModelTest >> testPathComputation [
	| blog post |
	blog := FOWebFolder new.
	root at: #blog put: blog.
	post := FOWebResource new.
	blog at: #'my-post' put: post.
	self assert: post path pathString equals: '/blog/my-post'
]

{ #category : #tests }
FOWebResourceModelTest >> testPublishPathMirrorsContentPathByDefault [
	| blog post |
	blog := FOWebFolder new.
	root at: #blog put: blog.
	post := FOWebResource new.
	blog at: #'my-post' put: post.
	self assert: post publishPath asString equals: 'docs/blog/my-post' asFileReference asString
]

{ #category : #tests }
FOWebResourceModelTest >> testResolvePathAutoCreatesMissingFolders [
	| resolved |
	resolved := root resolvePath: (RelativePath from: 'blog/2020').
	self assert: (resolved isKindOf: FOWebFolder).
	self assert: resolved name equals: '2020'.
	self assert: resolved parent name equals: 'blog'.
	self assert: resolved parent parent equals: root
]

{ #category : #tests }
FOWebResourceModelTest >> testResolvePathReturnsSameFolderOnRepeatedNavigation [
	| first second |
	first := root resolvePath: (RelativePath from: 'blog').
	second := root resolvePath: (RelativePath from: 'blog').
	self assert: first equals: second
]

{ #category : #tests }
FOWebResourceModelTest >> testAllPagesFiltersByIsPage [
	| page folder |
	page := FOTestPageDouble new.
	root at: #about put: page.
	folder := FOWebFolder new.
	root at: #blog put: folder.
	self assert: root allPages size equals: 1.
	self assert: (root allPages includes: page)
]
