Class {
	#name : #FOTagIndexBuilder,
	#superclass : #Object,
	#instVars : [
		'blog'
	],
	#category : #'Foliage-Core-Blog'
}

{ #category : #accessing }
FOTagIndexBuilder >> blog: aBlog [
	blog := aBlog
]

{ #category : #building }
FOTagIndexBuilder >> buildPage [
	"One entry per tag, each rendered through the 'tag-abstract' template via
	FOTag>>renderAbstract (title/pathString/abstract/postCount) - same
	approach as FOSeriesIndexBuilder, listing blog tags (newest-active-first,
	see FOBlog>>tags) instead of individual posts."
	| html |
	html := String streamContents: [ :s |
		blog tags do: [ :aTag | s nextPutAll: aTag renderAbstract ] ].
	^ FOFoliagePage new
		parent: blog parent;
		title: 'Tags';
		layout: blog layout;
		bodyHtml: html;
		yourself
]
