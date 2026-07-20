Class {
	#name : #FOBrokenTestReader,
	#superclass : #FORawReader,
	#category : #'Foliage-Core-Tests'
}

{ #category : #testing }
FOBrokenTestReader class >> supportedFileExtensions [
	^ #( broken )
]

{ #category : #accessing }
FOBrokenTestReader >> model [
	^ self error: 'simulated broken read'
]
