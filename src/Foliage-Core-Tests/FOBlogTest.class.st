Class {
	#name : #FOBlogTest,
	#superclass : #TestCase,
	#instVars : [
		'blog'
	],
	#category : #'Foliage-Core-Tests'
}

{ #category : #private }
FOBlogTest >> makePostTitled: aTitle publishDate: aDateString [
	^ FOFoliagePage new
		meta: (Dictionary new
			at: #title put: aTitle;
			at: #publishDate put: aDateString;
			yourself);
		document: (FOMarkdownParser parse: 'Text about ', aTitle, '.');
		yourself
]

{ #category : #running }
FOBlogTest >> setUp [
	super setUp.
	blog := FOBlog new
]

{ #category : #tests }
FOBlogTest >> testInsertingAFoliagePageAdaptsItToABlogPost [
	| inserted |
	blog at: #'post-one' put: (self makePostTitled: 'One' publishDate: '2020-01-01').
	inserted := blog / #'post-one'.
	self assert: (inserted isKindOf: FOBlogPost).
	self assert: inserted title equals: 'One'.
	self assert: inserted isPost
]

{ #category : #tests }
FOBlogTest >> testNonPageResourcesAreNotAdapted [
	| image |
	image := FOWebImage new.
	blog at: #'logo.png' put: image.
	self assert: (blog / #'logo.png') class equals: FOWebImage
]

{ #category : #tests }
FOBlogTest >> testPostsAndPublishedPosts [
	blog at: #'post-one' put: (self makePostTitled: 'One' publishDate: '2020-01-01').
	blog at: #'post-two' put: (self makePostTitled: 'Two' publishDate: '').
	blog at: #'not-a-post' put: FOWebImage new.
	self assert: blog posts size equals: 2.
	self assert: blog publishedPosts size equals: 1.
	self assert: blog publishedPosts first title equals: 'One'
]

{ #category : #tests }
FOBlogTest >> testSortedByPublishDateAndNextPreviousPost [
	| jan feb mar sorted |
	blog at: #jan put: (self makePostTitled: 'Jan' publishDate: '2020-01-01').
	blog at: #feb put: (self makePostTitled: 'Feb' publishDate: '2020-02-01').
	blog at: #mar put: (self makePostTitled: 'Mar' publishDate: '2020-03-01').
	jan := blog / #jan.
	feb := blog / #feb.
	mar := blog / #mar.
	sorted := blog sortedByPublishDate.
	self assert: (sorted collect: #title) asArray equals: #('Jan' 'Feb' 'Mar').
	self assert: (blog postAfter: jan) equals: feb.
	self assert: (blog postAfter: mar) isNil.
	self assert: (blog postBefore: feb) equals: jan.
	self assert: (blog postBefore: jan) isNil
]

{ #category : #tests }
FOBlogTest >> testDefaultLayoutAndTitle [
	self assert: blog layout equals: 'blog'.
	self assert: blog title equals: 'Untitled'.
	blog title: 'My Blog'.
	self assert: blog title equals: 'My Blog'
]

{ #category : #tests }
FOBlogTest >> testBlogPathsCreatesAFOBlogDuringImport [
	"Exercises the mechanism wired up (but not yet testable) back when
	FOWebSite>>blogPaths and FOWebFolder>>newChildNamed: were added - FOBlog
	didn't exist yet at that point."
	| site resolved |
	site := FOTestBlogWebsite new.
	resolved := site resolvePath: (RelativePath from: 'blog').
	self assert: (resolved isKindOf: FOBlog).
	self assert: (site resolvePath: (RelativePath from: 'other')) class equals: FOWebFolder
]
