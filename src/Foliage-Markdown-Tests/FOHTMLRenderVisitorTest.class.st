"
Checks the HTML the renderer produces. The tests start from markdown source
rather than hand built nodes, because the contract that matters is source in,
HTML out - including where the newlines go, which CommonMark prescribes.
"
Class {
	#name : #FOHTMLRenderVisitorTest,
	#superclass : #TestCase,
	#category : #'Foliage-Markdown-Tests'
}

{ #category : #private }
FOHTMLRenderVisitorTest >> nl [
	^ String with: Character lf
]

{ #category : #private }
FOHTMLRenderVisitorTest >> render: aString [
	^ FOHTMLRenderVisitor render: (FOMarkdownParser parse: aString)
]

{ #category : #private }
FOHTMLRenderVisitorTest >> lines: anArrayOfLines [
	^ String streamContents: [ :out |
		anArrayOfLines do: [ :each | out nextPutAll: each; nextPut: Character lf ] ]
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderHeader [
	self assert: (self render: '## Hi') equals: '<h2>Hi</h2>' , self nl
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderParagraph [
	self assert: (self render: 'plain text') equals: '<p>plain text</p>' , self nl
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderParagraphEscapesHtml [
	self assert: (self render: 'Hello & \<world\>')
		equals: '<p>Hello &amp; &lt;world&gt;</p>' , self nl
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderParagraphEscapesQuotes [
	self assert: (self render: 'He said \"no\"')
		equals: '<p>He said &quot;no&quot;</p>' , self nl
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderDocumentPutsEachBlockOnItsOwnLine [
	self assert: (self render: (self lines: #( '# Title' '' 'Body text.' )))
		equals: (self lines: #( '<h1>Title</h1>' '<p>Body text.</p>' ))
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderFencedCodeWithLanguage [
	self assert: (self render: (self lines: #( '```smalltalk' '1 + 1' '```' )))
		equals: (self lines: #( '<pre><code class="language-smalltalk">1 + 1' '</code></pre>' ))
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderFencedCodeWithFoliageLanguageAttribute [
	"Foliage's older ```language=x spelling has to keep working: the existing blog
	 sources are full of it."
	self assert: (self render: (self lines: #( '```language=smalltalk' '1 + 1' '```' )))
		equals: (self lines: #( '<pre><code class="language-smalltalk">1 + 1' '</code></pre>' ))
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderCodeBlockEscapesHtml [
	self assert: (self render: (self lines: #( '```' '<b> & </b>' '```' )))
		equals: (self lines: #( '<pre><code>&lt;b&gt; &amp; &lt;/b&gt;' '</code></pre>' ))
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderIndentedCodeHasNoLanguage [
	self assert: (self render: '    fun no fun')
		equals: (self lines: #( '<pre><code>fun no fun' '</code></pre>' ))
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderBlockquoteWrapsBlocks [
	self assert: (self render: '> This is a quote')
		equals: (self lines: #( '<blockquote>' '<p>This is a quote</p>' '</blockquote>' ))
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderBlockquoteKeepsSoftBreakBetweenLines [
	self assert: (self render: (self lines: #( '> line one' '> line two' )))
		equals: (self lines: #( '<blockquote>' '<p>line one' 'line two</p>' '</blockquote>' ))
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderTightListHasNoParagraphs [
	self assert: (self render: (self lines: #( '- A' '- B' )))
		equals: (self lines: #( '<ul>' '<li>A</li>' '<li>B</li>' '</ul>' ))
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderLooseListWrapsItemsInParagraphs [
	self assert: (self render: (self lines: #( '- A' '' '- B' )))
		equals: (self lines: #( '<ul>' '<li>' '<p>A</p>' '</li>' '<li>' '<p>B</p>' '</li>' '</ul>' ))
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderOrderedListKeepsItsStartNumber [
	self assert: (self render: (self lines: #( '3. first' '4. second' )))
		equals: (self lines: #( '<ol start="3">' '<li>first</li>' '<li>second</li>' '</ol>' ))
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderNestedList [
	self assert: (self render: (self lines: #( '- A' '  1. first' '  2. second' '- B' )))
		equals: (self lines: #( '<ul>' '<li>A' '<ol>' '<li>first</li>' '<li>second</li>' '</ol>' '</li>' '<li>B</li>' '</ul>' ))
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderThematicBreak [
	self assert: (self render: '---') equals: '<hr />' , self nl
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderEmphasis [
	self assert: (self render: 'Some **bold** and _italic_.')
		equals: '<p>Some <strong>bold</strong> and <em>italic</em>.</p>' , self nl
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderCodeSpan [
	self assert: (self render: 'a `b + c` d')
		equals: '<p>a <code>b + c</code> d</p>' , self nl
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderLink [
	self assert: (self render: '[A text](http://a.link.to)')
		equals: '<p><a href="http://a.link.to">A text</a></p>' , self nl
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderLinkWithTitle [
	self assert: (self render: '[A text](http://a.link.to "the title")')
		equals: '<p><a href="http://a.link.to" title="the title">A text</a></p>' , self nl
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderSiteSchemeLinkIsLeftAlone [
	"Foliage resolves site: destinations later on, so the renderer must pass them
	 through unchanged."
	self assert: (self render: '[Structure](site:foo:test)')
		equals: '<p><a href="site:foo:test">Structure</a></p>' , self nl
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderImage [
	self assert: (self render: '![alt text](/images/x.png)')
		equals: '<p><img src="/images/x.png" alt="alt text" /></p>' , self nl
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderImageWithFoliageAttributes [
	self assert: (self render: '![alt text](/images/x.png class=u-max-full-width)')
		equals: '<p><img src="/images/x.png" alt="alt text" class="u-max-full-width" /></p>' , self nl
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderHardBreak [
	self assert: (self render: (self lines: #( 'foo\' 'bar' )))
		equals: (self lines: #( '<p>foo<br />' 'bar</p>' ))
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderRawHtmlBlockIsVerbatim [
	| iframe |
	iframe := '<iframe src="/crowdsec.html" style="width:100%; height:800px;"></iframe>'.
	self assert: (self render: iframe) equals: iframe , self nl
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderDocumentWithRawHtmlBlock [
	| iframe |
	iframe := '<iframe src="/x.html"></iframe>'.
	self assert: (self render: (self lines: { 'Some text.'. ''. iframe }))
		equals: (self lines: { '<p>Some text.</p>'. iframe })
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderInlineHtmlIsVerbatimButTextIsEscaped [
	self assert: (self render: '5 < 3 and <b>bold</b>')
		equals: '<p>5 &lt; 3 and <b>bold</b></p>' , self nl
]

{ #category : #tests }
FOHTMLRenderVisitorTest >> testRenderPercentEncodesUnsafeCharactersInDestination [
	self assert: (self render: '[a](/my uri)')
		equals: '<p>[a](/my uri)</p>' , self nl.
	self assert: (self render: '[a](</my uri>)')
		equals: '<p><a href="/my%20uri">a</a></p>' , self nl
]
