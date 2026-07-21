Class {
	#name : #FOPlainTextVisitor,
	#superclass : #FOVisitor,
	#category : #'Foliage-Markdown'
}

{ #category : #'instance creation' }
FOPlainTextVisitor class >> render: aNode [
	^ aNode acceptVisitor: self new
]

{ #category : #visiting }
FOPlainTextVisitor >> visitDocument: aDocument [
	^ String streamContents: [ :s |
		aDocument children
			do: [ :child | s nextPutAll: (child acceptVisitor: self) ]
			separatedBy: [ s nextPut: $  ] ]
]

{ #category : #visiting }
FOPlainTextVisitor >> visitHeader: aHeader [
	^ self renderChildren: aHeader
]

{ #category : #visiting }
FOPlainTextVisitor >> visitParagraph: aParagraph [
	^ self renderChildren: aParagraph
]

{ #category : #visiting }
FOPlainTextVisitor >> visitCodeBlock: aCodeBlock [
	^ aCodeBlock code
]

{ #category : #visiting }
FOPlainTextVisitor >> visitBlockquote: aBlockquote [
	^ self renderChildren: aBlockquote
]

{ #category : #visiting }
FOPlainTextVisitor >> visitList: aList [
	^ String streamContents: [ :s |
		aList items
			do: [ :item | s nextPutAll: (item acceptVisitor: self) ]
			separatedBy: [ s nextPut: $  ] ]
]

{ #category : #visiting }
FOPlainTextVisitor >> visitListItem: aListItem [
	^ self renderChildren: aListItem
]

{ #category : #visiting }
FOPlainTextVisitor >> visitText: aText [
	^ aText string
]

{ #category : #visiting }
FOPlainTextVisitor >> visitBold: aBold [
	^ aBold text
]

{ #category : #visiting }
FOPlainTextVisitor >> visitItalic: anItalic [
	^ anItalic text
]

{ #category : #visiting }
FOPlainTextVisitor >> visitLink: aLink [
	^ aLink text
]

{ #category : #visiting }
FOPlainTextVisitor >> visitImage: anImage [
	"An image has no textual content worth including in a plain-text abstract."
	^ ''
]

{ #category : #private }
FOPlainTextVisitor >> renderChildren: aBlockNode [
	^ String streamContents: [ :s |
		aBlockNode children do: [ :child | s nextPutAll: (child acceptVisitor: self) ] ]
]
