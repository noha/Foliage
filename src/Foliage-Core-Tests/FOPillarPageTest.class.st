Class {
	#name : #FOPillarPageTest,
	#superclass : #TestCase,
	#traits : 'FOTTestWebSite',
	#classTraits : 'FOTTestWebSite classTrait',
	#instVars : [
		'fs'
	],
	#category : #'Foliage-Core-Tests'
}

{ #category : #running }
FOPillarPageTest >> setUp [
	super setUp.

	self setUpFileSystem.
	self setUpTemplates.
	self setUpSources.
]

{ #category : #templates }
FOPillarPageTest >> simple [

	^ '<html>
<title>{{ name }}</title>
<body>
{{{ body }}}
</body>'
]

{ #category : #sources }
FOPillarPageTest >> simpleMicrodown [

	^ 'simple.md' -> 
'---
title: Simple MD
layout: simple
---
# Simple microdown
Hello World!'
]

{ #category : #data }
FOPillarPageTest >> someData [

	^ '{
	"site_logo": "images/esug-logo-small.jpg",
	"name": "ESUG",	
	"menu" : [
		{ "title" : "About Us",
		  "url" : "/about_us.html",
		  "has_subfiles" : true,
		  "submenu" : [ { 
				"title" : "About",
				"url" : "/about_us.html" 
				},
				{ 
				"title" : "Membership",
				"url" : "/membership.html" 
				},
				{ 
				"title" : "Become a Sponsor",
				"url" : "/become_sponsor.html" 
				}]
		},
		{ "title" : "Conferences",
		  "url" : "/conferences.html",
		  "has_subfiles" : true,
		  "submenu" : [ 
		  		{ 
				"title" : "2023",
				"url" : "/2023-Conference/conf2023.html" 
				},
		  		{ 
				"title" : "Past Conferences",
				"url" : "/conferences.html" 
				} ]
		}
	]
}'
 
]

{ #category : #tests }
FOPillarPageTest >> testMustacheTokenIsReplacedByBlankIfNoValueFoundInContext [

	| page htmlString |
	
	self setUpWebSite.
	page := (FOMicrodownReader file: srcDir / 'simple.md') model.
	page parent: (FOWebsiteRoot new
			 parent: website;
			 yourself).

	htmlString := page render.

	self
		assert: htmlString
		equals: '<html>
<title></title>
<body>
<h1>Simple microdown</h1><p>Hello World!</p>
</body>'
]

{ #category : #tests }
FOPillarPageTest >> testMustacheTokenIsReplacedIfValueFoundInContext [

	| page htmlString |
	
	self setUpWebSite.
	self setUpWebSiteDataWith: self someData.
	page := (FOMicrodownReader file: srcDir / 'simple.md') model.
	page parent: (FOWebsiteRoot new parent: website; yourself).
	
	htmlString := page render.
	
	self 
		assert: htmlString 
		equals: '<html>
<title>ESUG</title>
<body>
<h1>Simple microdown</h1><p>Hello World!</p>
</body>'
]
