Class {
	#name : #FOPillarTruncateVisitor,
	#superclass : #FOPillarRewriteVisitor,
	#instVars : [
		'post',
		'upperLimit',
		'amountOfCharacters',
		'stream'
	],
	#category : #'Foliage-Core-Visitor'
}

{ #category : #accessing }
FOPillarTruncateVisitor >> amountOfCharacters: aNumber [ 
	upperLimit := aNumber.
	amountOfCharacters := 0.
]

{ #category : #accessing }
FOPillarTruncateVisitor >> post: anObject [ 

	post := anObject.
	stream := String new writeStream.
	self start: anObject document copy.
	^ stream contents
]

{ #category : #visiting }
FOPillarTruncateVisitor >> visit: anObject [
	(amountOfCharacters >= upperLimit) ifTrue: [ 
		^ nil ].
	^ anObject accept: self
]

{ #category : #visiting }
FOPillarTruncateVisitor >> visitAll: aCollection [
	^ (aCollection 
		collect: [ :each | self visit: each ])
			reject: #isNil
]

{ #category : #'visiting-document' }
FOPillarTruncateVisitor >> visitFigure: anObject [
	"ignore figures in the abstract"
	^ self 
]

{ #category : #'visiting-document' }
FOPillarTruncateVisitor >> visitHeader: aPRHeader [
	"skip header in order not to copy the header text into the 
	abstract"
	^ self
]

{ #category : #'visiting-document' }
FOPillarTruncateVisitor >> visitText: aPRText [
	| text textSize | 
	
	textSize := aPRText text size.
	text := (amountOfCharacters + textSize >= upperLimit) 
		ifTrue: [ aPRText text truncateWithElipsisTo: (10 max: (upperLimit - amountOfCharacters)) ]
		ifFalse: [ aPRText text ].
	aPRText text: text.
	stream << text.	
	amountOfCharacters := amountOfCharacters + aPRText text size.
	
	^ aPRText 
]
