Extension { #name : #FOWebSite }

{ #category : #'*Foliage-Feed' }
FOWebSite >> rssFeed [
	| template visitor feed |
	template := (self templatePath / #'rss.xml') asMustacheTemplate. 
	visitor := FORSSVisitor new.
	feed := visitor visit: self blog.
	^ feed
	
]
