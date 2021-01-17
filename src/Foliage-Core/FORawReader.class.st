Class {
	#name : #FORawReader,
	#superclass : #Object,
	#instVars : [
		'file',
		'stream'
	],
	#category : #'Foliage-Core-Reader'
}

{ #category : #accessing }
FORawReader class >> file: aFileReference [
	^ self new file: aFileReference 
]

{ #category : #accessing }
FORawReader class >> forFileExtension: aString [ 
	^ (self allSubclasses reject: #isAbstract)
		detect: [ :each | each matchesFileExtension: aString ]
		ifNone: [  nil ]
]

{ #category : #testing }
FORawReader class >> matchesFileExtension: aString [ 
	^ self supportedFileExtensions includes: aString
]

{ #category : #accessing }
FORawReader >> file: aFileReference [ 
	file := aFileReference 
]

{ #category : #accessing }
FORawReader >> stream [ 
	^ stream ifNil: [ 
		stream := file readStream ]
]
