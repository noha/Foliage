Class {
	#name : #FOPillarTruncateVisitor,
	#superclass : #FOPillarRewriteVisitor,
	#instVars : [
		'post',
		'textSize',
		'sizeRange'
	],
	#category : #'Foliage-Core-Visitor'
}

{ #category : #accessing }
FOPillarTruncateVisitor >> post: anObject [ 
	post := anObject.
	^ self start: anObject pillar
]

{ #category : #accessing }
FOPillarTruncateVisitor >> size: anInterval [ 
	sizeRange := anInterval.
	textSize := 0.
]

{ #category : #visiting }
FOPillarTruncateVisitor >> visit: anObject [
	(textSize >= sizeRange last) ifTrue: [ 
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
						reference: ($/ join: post publishPath segments) asZnUrl;
						setChildren: (self visitAll: aPRHeader children)));
				yourself ]
		ifFalse: [ aPRHeader ]
]

{ #category : #'visiting-document' }
FOPillarTruncateVisitor >> visitText: aPRText [
	| s | 
	s := aPRText text size.
	(textSize + s > sizeRange last) ifTrue: [  
		aPRText text: (aPRText text truncateWithElipsisTo: (sizeRange last - textSize)) ].
	textSize := textSize + aPRText text size.
	^ aPRText 
]
