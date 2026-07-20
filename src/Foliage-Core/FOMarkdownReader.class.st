Class {
	#name : #FOMarkdownReader,
	#superclass : #FORawReader,
	#category : #'Foliage-Core-Reader'
}

{ #category : #testing }
FOMarkdownReader class >> supportedFileExtensions [
	^ #( md )
]

{ #category : #reading }
FOMarkdownReader >> model [
	| frontmatter |
	frontmatter := FOFrontmatterParser parse: file contents.
	^ FOFoliagePage new
		sourcePath: file asPath;
		meta: frontmatter properties;
		document: (FOMarkdownParser parse: frontmatter body);
		yourself
]
