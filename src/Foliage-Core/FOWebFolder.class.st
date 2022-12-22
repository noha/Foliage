Class {
	#name : #FOWebFolder,
	#superclass : #FOWebContainer,
	#category : #'Foliage-Core-Model'
}

{ #category : #visiting }
FOWebFolder >> acceptFOVisitor: aFOVisitor [ 
	^ aFOVisitor visitWebFolder: self 
]

{ #category : #'as yet unclassified' }
FOWebFolder >> buildRssFeed [
	^ (FORSSVisitor new
		visit: self)
			parent: self
]

{ #category : #'as yet unclassified' }
FOWebFolder >> convertToBlog [ 
	| blog |
	blog := FOBlog new
		title: 'Blog';
		parent: parent;
		setItems: (self publishedItems associations collect: [ :assoc |
			assoc value isPage 
				ifTrue: [ assoc key -> (assoc value asFOBlogPost) ]
				ifFalse: [ assoc ] ] ) asDictionary.
	parent 
		replace: self 
		with: blog.
	^ blog
		
]

{ #category : #'as yet unclassified' }
FOWebFolder >> createOnTarget [
	self publishPath ensureCreateDirectory 
]

{ #category : #'as yet unclassified' }
FOWebFolder >> emitSelectors [

	^ #(name)
]

{ #category : #'as yet unclassified' }
FOWebFolder >> gtInspectorItemsIn: composite [
	<gtInspectorPresentationOrder: 0>
	^ composite fastTable 
		title: 'Items';
		display: [ 
			self isRoot 
				ifTrue: [ items values ]
				ifFalse: [ 
					items values asOrderedCollection 
						addFirst: self parent;
						yourself ] ];
		column: 'Name' evaluated: [:each | (self isChildOf: each) 
			ifTrue: [ '..' ] 
			ifFalse: [ each displayString ]] width: 400
		
]

{ #category : #testing }
FOWebFolder >> isRoot [
	^ false
]

{ #category : #accessing }
FOWebFolder >> name [
	^ parent nameOf: self
]

{ #category : #printing }
FOWebFolder >> printOn: aStream [
	aStream << self path asString << '/'
]

{ #category : #'as yet unclassified' }
FOWebFolder >> publishedItems [ 
	| newItems |
	"prevent unpublished pages from being included in the generated site"
	newItems := items species new.
	items keysAndValuesDo: [ :key :item | 
		item isPage 
			ifTrue: [
				item isPublished ifTrue: [ 
					newItems at: key put: item ] ]
			ifFalse: [ 
				newItems at: key put: item ] ].
	^ newItems
]

{ #category : #'as yet unclassified' }
FOWebFolder >> replace: oldResource with: newResource [ 
	items 
		at: oldResource name 
		put: newResource 
]

{ #category : #resolving }
FOWebFolder >> resolvePath: aRelativePath [ 
	| child |
	aRelativePath isEmpty ifTrue: [ ^ self ].
	child := items 
		at: aRelativePath segments first
		ifAbsentPut: [ 
			FOWebFolder new 
				parent: self ].
	^ child resolvePath: (RelativePath withAll: aRelativePath segments allButFirst)
]

{ #category : #'as yet unclassified' }
FOWebFolder >> rssFeed [
	^ self 
		propertyAt: #rssFeed
		ifAbsentPut: [ self buildRssFeed ]
]
