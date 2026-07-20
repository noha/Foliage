Class {
	#name : #FOWebFolder,
	#superclass : #FOWebContainer,
	#category : #'Foliage-Core-Model'
}

{ #category : #visiting }
FOWebFolder >> acceptFOVisitor: aFOVisitor [
	^ aFOVisitor visitWebFolder: self
]

{ #category : #actions }
FOWebFolder >> createOnTarget [
	self publishPath ensureCreateDirectory
]

{ #category : #testing }
FOWebFolder >> isRoot [
	^ false
]

{ #category : #printing }
FOWebFolder >> printOn: aStream [
	aStream << self path asString << '/'
]

{ #category : #resolving }
FOWebFolder >> resolvePath: aRelativePath [
	"Missing folders are always auto-created while navigating - deliberately
	consistent (the old FOBlog subclass diverged from this and raised an Error
	instead; that divergence is not kept)."
	| segment child |
	aRelativePath isEmpty ifTrue: [ ^ self ].
	segment := aRelativePath segments first.
	child := items at: segment ifAbsent: [
		| newChild |
		newChild := FOWebFolder new.
		self at: segment put: newChild.
		newChild ].
	^ child resolvePath: (RelativePath withAll: aRelativePath segments allButFirst)
]
