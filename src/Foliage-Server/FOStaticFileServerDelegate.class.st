Class {
	#name : #FOStaticFileServerDelegate,
	#superclass : #ZnStaticFileServerDelegate,
	#category : #'Foliage-Server'
}

{ #category : #private }
FOStaticFileServerDelegate >> actualFilenameFor: uri [

	^ (super actualFilenameFor: uri)
		ifNil: [ super actualFilenameFor: (self tryHtml: uri) ]
]

{ #category : #private }
FOStaticFileServerDelegate >> redirectNeededFor: uri actualFilename: actualFilename [

	uri isDirectoryPath ifTrue: [ ^ false ].  
	^ (actualFilename endsWith: uri lastPathSegment) not 
		and: [ (actualFilename endsWith: '.html') not ]
]

{ #category : #private }
FOStaticFileServerDelegate >> tryHtml: uri [
	| newUri |

	newUri := uri copy removeLastPathSegment.
	newUri addPathSegment: uri lastPathSegment, '.html'.

	^ newUri
]
