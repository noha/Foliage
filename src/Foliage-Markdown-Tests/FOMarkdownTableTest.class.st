"
Checks pipe tables, the GitHub flavoured extension to CommonMark: a header row, a
delimiter row that also sets the column alignment, and body rows. The tests go
from markdown source to HTML (and to plain text), because that is the contract a
blog post depends on. Tables that fall outside the rules must stay what
CommonMark says they are, a paragraph.
"
Class {
	#name : #FOMarkdownTableTest,
	#superclass : #TestCase,
	#category : #'Foliage-Markdown-Tests'
}

{ #category : #private }
FOMarkdownTableTest >> lines: anArrayOfLines [
	^ String streamContents: [ :out |
		anArrayOfLines do: [ :each | out nextPutAll: each; nextPut: Character lf ] ]
]

{ #category : #private }
FOMarkdownTableTest >> render: anArrayOfLines [
	^ FOHTMLRenderVisitor render: (FOMarkdownParser parse: (self lines: anArrayOfLines))
]

{ #category : #tests }
FOMarkdownTableTest >> testAlignmentFollowsTheDelimiterRow [
	self
		assert: (self render: #( '| l | c | r | n |' '|:--|:-:|--:|---|' '| 1 | 2 | 3 | 4 |' ))
		equals: (self lines: #(
			'<table>'
			'<thead>'
			'<tr>'
			'<th align="left">l</th>'
			'<th align="center">c</th>'
			'<th align="right">r</th>'
			'<th>n</th>'
			'</tr>'
			'</thead>'
			'<tbody>'
			'<tr>'
			'<td align="left">1</td>'
			'<td align="center">2</td>'
			'<td align="right">3</td>'
			'<td>4</td>'
			'</tr>'
			'</tbody>'
			'</table>' ))
]

{ #category : #tests }
FOMarkdownTableTest >> testCellsAreParsedAsInlines [
	self
		assert: (self render: #( '| a | b |' '|---|---|' '| *big* & more | [x](/y) |' ))
		equals: (self lines: #(
			'<table>'
			'<thead>'
			'<tr>'
			'<th>a</th>'
			'<th>b</th>'
			'</tr>'
			'</thead>'
			'<tbody>'
			'<tr>'
			'<td><em>big</em> &amp; more</td>'
			'<td><a href="/y">x</a></td>'
			'</tr>'
			'</tbody>'
			'</table>' ))
]

{ #category : #tests }
FOMarkdownTableTest >> testCodeSpanInACell [
	self
		assert: (self render: #( '| key | value |' '|---|---|' '| `a b` | 98 |' ))
		equals: (self lines: #(
			'<table>'
			'<thead>'
			'<tr>'
			'<th>key</th>'
			'<th>value</th>'
			'</tr>'
			'</thead>'
			'<tbody>'
			'<tr>'
			'<td><code>a b</code></td>'
			'<td>98</td>'
			'</tr>'
			'</tbody>'
			'</table>' ))
]

{ #category : #tests }
FOMarkdownTableTest >> testDelimiterRowWithOtherColumnCountIsNoTable [
	self
		assert: (self render: #( '| a | b |' '|---|' '| 1 | 2 |' ))
		equals: (self lines: #( '<p>| a | b |' '|---|' '| 1 | 2 |</p>' ))
]

{ #category : #tests }
FOMarkdownTableTest >> testDelimiterRowWithoutPipeIsStillASetextHeading [
	self
		assert: (self render: #( 'a' '---' ))
		equals: (self lines: #( '<h2>a</h2>' ))
]

{ #category : #tests }
FOMarkdownTableTest >> testEscapedPipeStaysInTheCell [
	self
		assert: (self render: #( '| a | b |' '|---|---|' '| x \| y | z |' ))
		equals: (self lines: #(
			'<table>'
			'<thead>'
			'<tr>'
			'<th>a</th>'
			'<th>b</th>'
			'</tr>'
			'</thead>'
			'<tbody>'
			'<tr>'
			'<td>x | y</td>'
			'<td>z</td>'
			'</tr>'
			'</tbody>'
			'</table>' ))
]

{ #category : #tests }
FOMarkdownTableTest >> testHeaderOnlyTableHasNoBody [
	self
		assert: (self render: #( '| a | b |' '|---|---|' ))
		equals: (self lines: #(
			'<table>'
			'<thead>'
			'<tr>'
			'<th>a</th>'
			'<th>b</th>'
			'</tr>'
			'</thead>'
			'</table>' ))
]

{ #category : #tests }
FOMarkdownTableTest >> testParagraphLinesBeforeTheHeaderStayAParagraph [
	self
		assert: (self render: #( 'Some intro' '| a |' '|---|' '| 1 |' ))
		equals: (self lines: #(
			'<p>Some intro</p>'
			'<table>'
			'<thead>'
			'<tr>'
			'<th>a</th>'
			'</tr>'
			'</thead>'
			'<tbody>'
			'<tr>'
			'<td>1</td>'
			'</tr>'
			'</tbody>'
			'</table>' ))
]

{ #category : #tests }
FOMarkdownTableTest >> testPlainTextOfATableIsItsCellText [
	| document |
	document := FOMarkdownParser parse: (self lines: #( '| a | b |' '|---|---|' '| 1 | `2` |' )).
	self assert: (FOPlainTextVisitor render: document) equals: 'a b 1 2'
]

{ #category : #tests }
FOMarkdownTableTest >> testRowsWithTooFewOrTooManyCellsFitTheHeader [
	self
		assert: (self render: #( '| a | b |' '|---|---|' '| 1 |' '| 1 | 2 | 3 |' ))
		equals: (self lines: #(
			'<table>'
			'<thead>'
			'<tr>'
			'<th>a</th>'
			'<th>b</th>'
			'</tr>'
			'</thead>'
			'<tbody>'
			'<tr>'
			'<td>1</td>'
			'<td></td>'
			'</tr>'
			'<tr>'
			'<td>1</td>'
			'<td>2</td>'
			'</tr>'
			'</tbody>'
			'</table>' ))
]

{ #category : #tests }
FOMarkdownTableTest >> testSimpleTable [
	self
		assert: (self render: #( '| a | b |' '|---|---|' '| 1 | 2 |' '| 3 | 4 |' ))
		equals: (self lines: #(
			'<table>'
			'<thead>'
			'<tr>'
			'<th>a</th>'
			'<th>b</th>'
			'</tr>'
			'</thead>'
			'<tbody>'
			'<tr>'
			'<td>1</td>'
			'<td>2</td>'
			'</tr>'
			'<tr>'
			'<td>3</td>'
			'<td>4</td>'
			'</tr>'
			'</tbody>'
			'</table>' ))
]

{ #category : #tests }
FOMarkdownTableTest >> testTableEndsAtABlankLine [
	self
		assert: (self render: #( '| a |' '|---|' '| 1 |' '' 'after' ))
		equals: (self lines: #(
			'<table>'
			'<thead>'
			'<tr>'
			'<th>a</th>'
			'</tr>'
			'</thead>'
			'<tbody>'
			'<tr>'
			'<td>1</td>'
			'</tr>'
			'</tbody>'
			'</table>'
			'<p>after</p>' ))
]

{ #category : #tests }
FOMarkdownTableTest >> testTableWithoutOuterPipes [
	self
		assert: (self render: #( 'a | b' '--- | ---' '1 | 2' ))
		equals: (self lines: #(
			'<table>'
			'<thead>'
			'<tr>'
			'<th>a</th>'
			'<th>b</th>'
			'</tr>'
			'</thead>'
			'<tbody>'
			'<tr>'
			'<td>1</td>'
			'<td>2</td>'
			'</tr>'
			'</tbody>'
			'</table>' ))
]
