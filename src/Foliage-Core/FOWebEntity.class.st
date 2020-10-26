Class {
	#name : #FOWebEntity,
	#superclass : #FOWebResource,
	#instVars : [
		'raw'
	],
	#category : #'Foliage-Core-Model'
}

{ #category : #testing }
FOWebEntity class >> isAbstract [ 
	^ self == FOWebEntity
]

{ #category : #copying }
FOWebEntity >> duplicate [ 
	^ self copy resetParent
]

{ #category : #accessing }
FOWebEntity >> name [
	^ parent nameOf: self
]

{ #category : #printing }
FOWebEntity >> printOn: aStream [ 
	aStream << 'leaf: ' << self path asString 
]

{ #category : #accessing }
FOWebEntity >> raw: aFileReference [ 
	raw := aFileReference 
]
