Class {
	#name : #FOWebFolder,
	#superclass : #FOWebContainer,
	#category : #'Foliage-Core-Model'
}

{ #category : #visiting }
FOWebFolder >> acceptFOVisitor: aFOVisitor [
	^ aFOVisitor visitWebFolder: self
]

{ #category : #actions }
FOWebFolder >> createOnTarget [
	self publishPath ensureCreateDirectory
]

{ #category : #testing }
FOWebFolder >> isRoot [
	^ false
]

{ #category : #printing }
FOWebFolder >> printOn: aStream [
	aStream << self path asString << '/'
]

{ #category : #accessing }
FOWebFolder >> pathString [
	"The base FOWebResource>>pathString forces a .html extension, correct for
	pages but wrong for a folder's own link (would produce '/blog.html'
	instead of '/blog') - only found because deriving an RSS channel's link
	from the blog itself (rather than the old hardcoded literal) newly
	exercises this path; a folder was apparently never linked to directly
	before."
	^ self path pathString
]

{ #category : #resolving }
FOWebFolder >> resolvePath: aRelativePath [
	"Missing folders are always auto-created while navigating - deliberately
	consistent (the old FOBlog subclass diverged from this and raised an Error
	instead; that divergence is not kept)."
	| segment child |
	aRelativePath isEmpty ifTrue: [ ^ self ].
	segment := aRelativePath segments first.
	child := items at: segment ifAbsent: [
		| newChild |
		newChild := self newChildNamed: segment.
		self at: segment put: newChild.
		newChild ].
	^ child resolvePath: (RelativePath withAll: aRelativePath segments allButFirst)
]

{ #category : #resolving }
FOWebFolder >> newChildNamed: aString [
	"A top-level (direct child of root) name declared via the website's
	blogPaths becomes a FOBlog right away, instead of a plain FOWebFolder -
	replaces the old post-hoc convertToBlog object surgery."
	^ (self isRoot and: [ self website blogPaths includes: aString ])
		ifTrue: [ FOBlog new ]
		ifFalse: [ FOWebFolder new ]
]
