Class {
	#name : #FOMicrodownReader,
	#superclass : #FORawReader,
	#category : #'Foliage-Core'
}

{ #category : #testing }
FOMicrodownReader class >> supportedFileExtensions [
	^ #( md )
]

{ #category : #reading }
FOMicrodownReader >> model [
	^ FOPillarPage new
		sourcePath: file asPath;
		meta: (self readMetaFrom: self stream);
		document: (self readDocumentFrom: self stream). 

]

{ #category : #reading }
FOMicrodownReader >> readDocumentFrom: aStream [
	^ (MicroDownParser parse: aStream upToEnd) asPillar. 

]

{ #category : #generation }
FOMicrodownReader >> readJsonFrom: aStream [
	^ (NeoJSONReader on: aStream) next
	
]

{ #category : #generation }
FOMicrodownReader >> readMetaFrom: aStream [
	^ self readJsonFrom: aStream
]
