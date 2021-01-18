Class {
	#name : #FOSkeletonTheme,
	#superclass : #FOTheme,
	#category : #'Foliage-Core-Base'
}

{ #category : #'as yet unclassified' }
FOSkeletonTheme >> archiveName [
	^ 'Skeleton-2.0.4.zip'
]

{ #category : #'as yet unclassified' }
FOSkeletonTheme >> copyResources [
	| zip member stream |
	zip := ZipArchive new 
		readFrom: self archiveName asFileReference binaryReadStream.
	member := zip memberNamed: 'Skeleton-2.0.4/css/normalize.css'.
	'raw/css' asFileReference ensureCreateDirectory.
	stream := 'raw/css/normalize.css' asFileReference binaryWriteStream.
	member extractTo: stream.
	stream 
		flush;
		close.
	member := zip memberNamed: 'Skeleton-2.0.4/css/skeleton.css'.
	stream := 'raw/css/skeleton.css' asFileReference binaryWriteStream.
	member extractTo: stream.
	stream 
		flush;
		close.
]

{ #category : #'as yet unclassified' }
FOSkeletonTheme >> createPageTemplate [
	'template' asFileReference ensureCreateDirectory.
	'template/page' asFileReference binaryWriteStream 
		nextPutAll: (self pageTemplate copyReplaceAll: String cr with: String crlf);
		close
]

{ #category : #'as yet unclassified' }
FOSkeletonTheme >> downloadSkeleton [
	self archiveName asFileReference exists ifFalse: [  
		ZnClient new 
			url: 'https://github.com/dhg/Skeleton/releases/download/2.0.4/', self archiveName;
			downloadTo: '.' asFileReference ]
]

{ #category : #'as yet unclassified' }
FOSkeletonTheme >> install [
	self downloadSkeleton.
	self copyResources.
	self createPageTemplate
]

{ #category : #'as yet unclassified' }
FOSkeletonTheme >> pageTemplate [ 
	^ '<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>{{page.title}}</title>
  <meta name="description" content="">
  <meta name="author" content="">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="//fonts.googleapis.com/css?family=Raleway:400,300,600" rel="stylesheet" type="text/css">
  <link rel="stylesheet" href="/css/normalize.css">
  <link rel="stylesheet" href="/css/skeleton.css">
  <link rel="icon" type="image/png" href="/images/favicon.png">

</head>
<body style="font-size: 1.8rem">
  <div class="container">
    <div class="row">
      <div class="twelve columns" style="margin-top: 10%">
          {{{ body }}}
      </div>
    </div>
  </div>

</body>
</html>'
]
