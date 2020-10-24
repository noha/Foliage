Class {
	#name : #FOTextEntity,
	#superclass : #FOWebEntity,
	#category : #'Foliage-Core-Model'
}

{ #category : #testing }
FOTextEntity class >> isAbstract [ 
	^ self == FOTextEntity  
]
