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
FOPillarTruncateVisitor >> visitHeader: aPRHeader [
	^ (aPRHeader level = 1)
		ifTrue: [  
			aPRHeader 
				setChildren: (
					Array with: (PRExternalLink new 
						reference: (post path withExtension: #html) pathString asZnUrl ;
						setChildren: (self visitAll: aPRHeader children)));
				yourself ]
		ifFalse: [ aPRHeader ]
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
