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

{ #category : #'as yet unclassified' }
FOWebEntity >> publishPath [
	self flag: #todo.
	"path is not properly defined. When there is raw path and when publich path?"
	^ self relativePath  
]

{ #category : #accessing }
FOWebEntity >> raw: aFileReference [ 
	raw := aFileReference 
]

{ #category : #'as yet unclassified' }
FOWebEntity >> realPublishPath [
	self flag: #todo.
	"path is not properly defined. When there is raw path and when publich path?"
	^ self website targetPath resolve: self relativePath  
]
