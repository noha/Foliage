"
Checks the parser against examples taken verbatim from the CommonMark 0.31.2
specification, a handful per section. The full suite of 655 examples is not
carried in this repository; these are the ones kept as a standing regression net,
so a change that breaks a whole construct fails here rather than on a blog page.

Each test states the markdown source and the HTML the spec demands, line by line.
"
Class {
	#name : #FOCommonMarkSpecTest,
	#superclass : #TestCase,
	#category : #'Foliage-Markdown-Tests'
}

{ #category : #private }
FOCommonMarkSpecTest >> assertSource: sourceLines rendersAs: htmlLines [
	| source expected actual |
	source := self join: sourceLines.
	expected := self join: htmlLines.
	actual := FOHTMLRenderVisitor render: (FOMarkdownParser parse: source).
	self assert: actual equals: expected
]

{ #category : #private }
FOCommonMarkSpecTest >> join: anArrayOfLines [
	anArrayOfLines isEmpty ifTrue: [ ^ '' ].
	^ String streamContents: [ :out |
		anArrayOfLines do: [ :each | out nextPutAll: each; nextPut: Character lf ] ]
]

{ #category : #'tests - atx headings' }
FOCommonMarkSpecTest >> testAtxHeadings1 [
	"CommonMark 0.31.2, example 62"
	self
		assertSource: #( '# foo' '## foo' '### foo' '#### foo' '##### foo' '###### foo' )
		rendersAs: #( '<h1>foo</h1>' '<h2>foo</h2>' '<h3>foo</h3>' '<h4>foo</h4>' '<h5>foo</h5>' '<h6>foo</h6>' )
]

{ #category : #'tests - atx headings' }
FOCommonMarkSpecTest >> testAtxHeadings2 [
	"CommonMark 0.31.2, example 63"
	self
		assertSource: #( '####### foo' )
		rendersAs: #( '<p>####### foo</p>' )
]

{ #category : #'tests - atx headings' }
FOCommonMarkSpecTest >> testAtxHeadings3 [
	"CommonMark 0.31.2, example 64"
	self
		assertSource: #( '#5 bolt' '' '#hashtag' )
		rendersAs: #( '<p>#5 bolt</p>' '<p>#hashtag</p>' )
]

{ #category : #'tests - setext headings' }
FOCommonMarkSpecTest >> testSetextHeadings1 [
	"CommonMark 0.31.2, example 80"
	self
		assertSource: #( 'Foo *bar*' '=========' '' 'Foo *bar*' '---------' )
		rendersAs: #( '<h1>Foo <em>bar</em></h1>' '<h2>Foo <em>bar</em></h2>' )
]

{ #category : #'tests - setext headings' }
FOCommonMarkSpecTest >> testSetextHeadings2 [
	"CommonMark 0.31.2, example 81"
	self
		assertSource: #( 'Foo *bar' 'baz*' '====' )
		rendersAs: #( '<h1>Foo <em>bar' 'baz</em></h1>' )
]

{ #category : #'tests - setext headings' }
FOCommonMarkSpecTest >> testSetextHeadings3 [
	"CommonMark 0.31.2, example 83"
	self
		assertSource: #( 'Foo' '-------------------------' '' 'Foo' '=' )
		rendersAs: #( '<h2>Foo</h2>' '<h1>Foo</h1>' )
]

{ #category : #'tests - thematic breaks' }
FOCommonMarkSpecTest >> testThematicBreaks1 [
	"CommonMark 0.31.2, example 43"
	self
		assertSource: #( '***' '---' '___' )
		rendersAs: #( '<hr />' '<hr />' '<hr />' )
]

{ #category : #'tests - thematic breaks' }
FOCommonMarkSpecTest >> testThematicBreaks2 [
	"CommonMark 0.31.2, example 44"
	self
		assertSource: #( '+++' )
		rendersAs: #( '<p>+++</p>' )
]

{ #category : #'tests - thematic breaks' }
FOCommonMarkSpecTest >> testThematicBreaks3 [
	"CommonMark 0.31.2, example 45"
	self
		assertSource: #( '===' )
		rendersAs: #( '<p>===</p>' )
]

{ #category : #'tests - indented code blocks' }
FOCommonMarkSpecTest >> testIndentedCodeBlocks1 [
	"CommonMark 0.31.2, example 107"
	self
		assertSource: #( '    a simple' '      indented code block' )
		rendersAs: #( '<pre><code>a simple' '  indented code block' '</code></pre>' )
]

{ #category : #'tests - indented code blocks' }
FOCommonMarkSpecTest >> testIndentedCodeBlocks2 [
	"CommonMark 0.31.2, example 108"
	self
		assertSource: #( '  - foo' '' '    bar' )
		rendersAs: #( '<ul>' '<li>' '<p>foo</p>' '<p>bar</p>' '</li>' '</ul>' )
]

{ #category : #'tests - indented code blocks' }
FOCommonMarkSpecTest >> testIndentedCodeBlocks3 [
	"CommonMark 0.31.2, example 109"
	self
		assertSource: #( '1.  foo' '' '    - bar' )
		rendersAs: #( '<ol>' '<li>' '<p>foo</p>' '<ul>' '<li>bar</li>' '</ul>' '</li>' '</ol>' )
]

{ #category : #'tests - fenced code blocks' }
FOCommonMarkSpecTest >> testFencedCodeBlocks1 [
	"CommonMark 0.31.2, example 119"
	self
		assertSource: #( '```' '<' ' >' '```' )
		rendersAs: #( '<pre><code>&lt;' ' &gt;' '</code></pre>' )
]

{ #category : #'tests - fenced code blocks' }
FOCommonMarkSpecTest >> testFencedCodeBlocks2 [
	"CommonMark 0.31.2, example 120"
	self
		assertSource: #( '~~~' '<' ' >' '~~~' )
		rendersAs: #( '<pre><code>&lt;' ' &gt;' '</code></pre>' )
]

{ #category : #'tests - fenced code blocks' }
FOCommonMarkSpecTest >> testFencedCodeBlocks3 [
	"CommonMark 0.31.2, example 121"
	self
		assertSource: #( '``' 'foo' '``' )
		rendersAs: #( '<p><code>foo</code></p>' )
]

{ #category : #'tests - html blocks' }
FOCommonMarkSpecTest >> testHtmlBlocks1 [
	"CommonMark 0.31.2, example 150"
	self
		assertSource: #( ' <div>' '  *hello*' '         <foo><a>' )
		rendersAs: #( ' <div>' '  *hello*' '         <foo><a>' )
]

{ #category : #'tests - html blocks' }
FOCommonMarkSpecTest >> testHtmlBlocks2 [
	"CommonMark 0.31.2, example 151"
	self
		assertSource: #( '</div>' '*foo*' )
		rendersAs: #( '</div>' '*foo*' )
]

{ #category : #'tests - html blocks' }
FOCommonMarkSpecTest >> testHtmlBlocks3 [
	"CommonMark 0.31.2, example 152"
	self
		assertSource: #( '<DIV CLASS="foo">' '' '*Markdown*' '' '</DIV>' )
		rendersAs: #( '<DIV CLASS="foo">' '<p><em>Markdown</em></p>' '</DIV>' )
]

{ #category : #'tests - link reference definitions' }
FOCommonMarkSpecTest >> testLinkReferenceDefinitions1 [
	"CommonMark 0.31.2, example 194"
	self
		assertSource: #( '[foo]: /url "title"' '' '[foo]' )
		rendersAs: #( '<p><a href="/url" title="title">foo</a></p>' )
]

{ #category : #'tests - link reference definitions' }
FOCommonMarkSpecTest >> testLinkReferenceDefinitions2 [
	"CommonMark 0.31.2, example 195"
	self
		assertSource: #( '   [foo]: ' '      /url  ' '           ''the title''  ' '' '[foo]' )
		rendersAs: #( '<p><a href="/url" title="the title">foo</a></p>' )
]

{ #category : #'tests - link reference definitions' }
FOCommonMarkSpecTest >> testLinkReferenceDefinitions3 [
	"CommonMark 0.31.2, example 196"
	self
		assertSource: #( '[Foo*bar\]]:my_(url) ''title (with parens)''' '' '[Foo*bar\]]' )
		rendersAs: #( '<p><a href="my_(url)" title="title (with parens)">Foo*bar]</a></p>' )
]

{ #category : #'tests - paragraphs' }
FOCommonMarkSpecTest >> testParagraphs1 [
	"CommonMark 0.31.2, example 221"
	self
		assertSource: #( 'aaa' '' 'bbb' )
		rendersAs: #( '<p>aaa</p>' '<p>bbb</p>' )
]

{ #category : #'tests - paragraphs' }
FOCommonMarkSpecTest >> testParagraphs2 [
	"CommonMark 0.31.2, example 222"
	self
		assertSource: #( 'aaa' 'bbb' '' 'ccc' 'ddd' )
		rendersAs: #( '<p>aaa' 'bbb</p>' '<p>ccc' 'ddd</p>' )
]

{ #category : #'tests - paragraphs' }
FOCommonMarkSpecTest >> testParagraphs3 [
	"CommonMark 0.31.2, example 223"
	self
		assertSource: #( 'aaa' '' '' 'bbb' )
		rendersAs: #( '<p>aaa</p>' '<p>bbb</p>' )
]

{ #category : #'tests - block quotes' }
FOCommonMarkSpecTest >> testBlockQuotes1 [
	"CommonMark 0.31.2, example 230"
	self
		assertSource: #( '> # Foo' '> bar' '> baz' )
		rendersAs: #( '<blockquote>' '<h1>Foo</h1>' '<p>bar' 'baz</p>' '</blockquote>' )
]

{ #category : #'tests - block quotes' }
FOCommonMarkSpecTest >> testBlockQuotes2 [
	"CommonMark 0.31.2, example 231"
	self
		assertSource: #( '># Foo' '>bar' '> baz' )
		rendersAs: #( '<blockquote>' '<h1>Foo</h1>' '<p>bar' 'baz</p>' '</blockquote>' )
]

{ #category : #'tests - block quotes' }
FOCommonMarkSpecTest >> testBlockQuotes3 [
	"CommonMark 0.31.2, example 232"
	self
		assertSource: #( '   > # Foo' '   > bar' ' > baz' )
		rendersAs: #( '<blockquote>' '<h1>Foo</h1>' '<p>bar' 'baz</p>' '</blockquote>' )
]

{ #category : #'tests - list items' }
FOCommonMarkSpecTest >> testListItems1 [
	"CommonMark 0.31.2, example 255"
	self
		assertSource: #( 'A paragraph' 'with two lines.' '' '    indented code' '' '> A block quote.' )
		rendersAs: #( '<p>A paragraph' 'with two lines.</p>' '<pre><code>indented code' '</code></pre>' '<blockquote>' '<p>A block quote.</p>' '</blockquote>' )
]

{ #category : #'tests - list items' }
FOCommonMarkSpecTest >> testListItems2 [
	"CommonMark 0.31.2, example 256"
	self
		assertSource: #( '1.  A paragraph' '    with two lines.' '' '        indented code' '' '    > A block quote.' )
		rendersAs: #( '<ol>' '<li>' '<p>A paragraph' 'with two lines.</p>' '<pre><code>indented code' '</code></pre>' '<blockquote>' '<p>A block quote.</p>' '</blockquote>' '</li>' '</ol>' )
]

{ #category : #'tests - list items' }
FOCommonMarkSpecTest >> testListItems3 [
	"CommonMark 0.31.2, example 257"
	self
		assertSource: #( '- one' '' ' two' )
		rendersAs: #( '<ul>' '<li>one</li>' '</ul>' '<p>two</p>' )
]

{ #category : #'tests - lists' }
FOCommonMarkSpecTest >> testLists1 [
	"CommonMark 0.31.2, example 303"
	self
		assertSource: #( '- foo' '- bar' '+ baz' )
		rendersAs: #( '<ul>' '<li>foo</li>' '<li>bar</li>' '</ul>' '<ul>' '<li>baz</li>' '</ul>' )
]

{ #category : #'tests - lists' }
FOCommonMarkSpecTest >> testLists2 [
	"CommonMark 0.31.2, example 304"
	self
		assertSource: #( '1. foo' '2. bar' '3) baz' )
		rendersAs: #( '<ol>' '<li>foo</li>' '<li>bar</li>' '</ol>' '<ol start="3">' '<li>baz</li>' '</ol>' )
]

{ #category : #'tests - lists' }
FOCommonMarkSpecTest >> testLists3 [
	"CommonMark 0.31.2, example 305"
	self
		assertSource: #( 'Foo' '- bar' '- baz' )
		rendersAs: #( '<p>Foo</p>' '<ul>' '<li>bar</li>' '<li>baz</li>' '</ul>' )
]

{ #category : #'tests - backslash escapes' }
FOCommonMarkSpecTest >> testBackslashEscapes1 [
	"CommonMark 0.31.2, example 12"
	self
		assertSource: #( '\!\"\#\$\%\&\''\(\)\*\+\,\-\.\/\:\;\<\=\>\?\@\[\\\]\^\_\`\{\|\}\~' )
		rendersAs: #( '<p>!&quot;#$%&amp;''()*+,-./:;&lt;=&gt;?@[\]^_`{|}~</p>' )
]

{ #category : #'tests - backslash escapes' }
FOCommonMarkSpecTest >> testBackslashEscapes2 [
	"CommonMark 0.31.2, example 15"
	self
		assertSource: #( '\\*emphasis*' )
		rendersAs: #( '<p>\<em>emphasis</em></p>' )
]

{ #category : #'tests - backslash escapes' }
FOCommonMarkSpecTest >> testBackslashEscapes3 [
	"CommonMark 0.31.2, example 16"
	self
		assertSource: #( 'foo\' 'bar' )
		rendersAs: #( '<p>foo<br />' 'bar</p>' )
]

{ #category : #'tests - entity and numeric character references' }
FOCommonMarkSpecTest >> testEntityAndNumericCharacterReferences1 [
	"CommonMark 0.31.2, example 25"
	self
		assertSource: #( '&nbsp; &amp; &copy; &AElig; &Dcaron;' '&frac34; &HilbertSpace; &DifferentialD;' '&ClockwiseContourIntegral; &ngE;' )
		rendersAs: #( '<p>  &amp; © Æ Ď' '¾ ℋ ⅆ' '∲ ≧̸</p>' )
]

{ #category : #'tests - entity and numeric character references' }
FOCommonMarkSpecTest >> testEntityAndNumericCharacterReferences2 [
	"CommonMark 0.31.2, example 26"
	self
		assertSource: #( '&#35; &#1234; &#992; &#0;' )
		rendersAs: #( '<p># Ӓ Ϡ �</p>' )
]

{ #category : #'tests - entity and numeric character references' }
FOCommonMarkSpecTest >> testEntityAndNumericCharacterReferences3 [
	"CommonMark 0.31.2, example 27"
	self
		assertSource: #( '&#X22; &#XD06; &#xcab;' )
		rendersAs: #( '<p>&quot; ആ ಫ</p>' )
]

{ #category : #'tests - code spans' }
FOCommonMarkSpecTest >> testCodeSpans1 [
	"CommonMark 0.31.2, example 330"
	self
		assertSource: #( '`foo`' )
		rendersAs: #( '<p><code>foo</code></p>' )
]

{ #category : #'tests - code spans' }
FOCommonMarkSpecTest >> testCodeSpans2 [
	"CommonMark 0.31.2, example 331"
	self
		assertSource: #( '`` foo ` bar ``' )
		rendersAs: #( '<p><code>foo ` bar</code></p>' )
]

{ #category : #'tests - code spans' }
FOCommonMarkSpecTest >> testCodeSpans3 [
	"CommonMark 0.31.2, example 332"
	self
		assertSource: #( '` `` `' )
		rendersAs: #( '<p><code>``</code></p>' )
]

{ #category : #'tests - emphasis and strong emphasis' }
FOCommonMarkSpecTest >> testEmphasisAndStrongEmphasis1 [
	"CommonMark 0.31.2, example 352"
	self
		assertSource: #( '*foo bar*' )
		rendersAs: #( '<p><em>foo bar</em></p>' )
]

{ #category : #'tests - emphasis and strong emphasis' }
FOCommonMarkSpecTest >> testEmphasisAndStrongEmphasis2 [
	"CommonMark 0.31.2, example 353"
	self
		assertSource: #( 'a * foo bar*' )
		rendersAs: #( '<p>a * foo bar*</p>' )
]

{ #category : #'tests - emphasis and strong emphasis' }
FOCommonMarkSpecTest >> testEmphasisAndStrongEmphasis3 [
	"CommonMark 0.31.2, example 354"
	self
		assertSource: #( 'a*"foo"*' )
		rendersAs: #( '<p>a*&quot;foo&quot;*</p>' )
]

{ #category : #'tests - links' }
FOCommonMarkSpecTest >> testLinks1 [
	"CommonMark 0.31.2, example 484"
	self
		assertSource: #( '[link](/uri "title")' )
		rendersAs: #( '<p><a href="/uri" title="title">link</a></p>' )
]

{ #category : #'tests - links' }
FOCommonMarkSpecTest >> testLinks2 [
	"CommonMark 0.31.2, example 485"
	self
		assertSource: #( '[link](/uri)' )
		rendersAs: #( '<p><a href="/uri">link</a></p>' )
]

{ #category : #'tests - links' }
FOCommonMarkSpecTest >> testLinks3 [
	"CommonMark 0.31.2, example 486"
	self
		assertSource: #( '[](./target.md)' )
		rendersAs: #( '<p><a href="./target.md"></a></p>' )
]

{ #category : #'tests - images' }
FOCommonMarkSpecTest >> testImages1 [
	"CommonMark 0.31.2, example 574"
	self
		assertSource: #( '![foo](/url "title")' )
		rendersAs: #( '<p><img src="/url" alt="foo" title="title" /></p>' )
]

{ #category : #'tests - images' }
FOCommonMarkSpecTest >> testImages2 [
	"CommonMark 0.31.2, example 575"
	self
		assertSource: #( '![foo *bar*]' '' '[foo *bar*]: train.jpg "train & tracks"' )
		rendersAs: #( '<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>' )
]

{ #category : #'tests - images' }
FOCommonMarkSpecTest >> testImages3 [
	"CommonMark 0.31.2, example 576"
	self
		assertSource: #( '![foo ![bar](/url)](/url2)' )
		rendersAs: #( '<p><img src="/url2" alt="foo bar" /></p>' )
]

{ #category : #'tests - autolinks' }
FOCommonMarkSpecTest >> testAutolinks1 [
	"CommonMark 0.31.2, example 596"
	self
		assertSource: #( '<http://foo.bar.baz>' )
		rendersAs: #( '<p><a href="http://foo.bar.baz">http://foo.bar.baz</a></p>' )
]

{ #category : #'tests - autolinks' }
FOCommonMarkSpecTest >> testAutolinks2 [
	"CommonMark 0.31.2, example 597"
	self
		assertSource: #( '<https://foo.bar.baz/test?q=hello&id=22&boolean>' )
		rendersAs: #( '<p><a href="https://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean">https://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean</a></p>' )
]

{ #category : #'tests - autolinks' }
FOCommonMarkSpecTest >> testAutolinks3 [
	"CommonMark 0.31.2, example 598"
	self
		assertSource: #( '<irc://foo.bar:2233/baz>' )
		rendersAs: #( '<p><a href="irc://foo.bar:2233/baz">irc://foo.bar:2233/baz</a></p>' )
]

{ #category : #'tests - raw html' }
FOCommonMarkSpecTest >> testRawHtml1 [
	"CommonMark 0.31.2, example 615"
	self
		assertSource: #( '<a><bab><c2c>' )
		rendersAs: #( '<p><a><bab><c2c></p>' )
]

{ #category : #'tests - raw html' }
FOCommonMarkSpecTest >> testRawHtml2 [
	"CommonMark 0.31.2, example 616"
	self
		assertSource: #( '<a/><b2/>' )
		rendersAs: #( '<p><a/><b2/></p>' )
]

{ #category : #'tests - raw html' }
FOCommonMarkSpecTest >> testRawHtml3 [
	"CommonMark 0.31.2, example 617"
	self
		assertSource: #( '<a  /><b2' 'data="foo" >' )
		rendersAs: #( '<p><a  /><b2' 'data="foo" ></p>' )
]

{ #category : #'tests - hard line breaks' }
FOCommonMarkSpecTest >> testHardLineBreaks1 [
	"CommonMark 0.31.2, example 636"
	self
		assertSource: #( 'foo  ' 'baz' )
		rendersAs: #( '<p>foo<br />' 'baz</p>' )
]

{ #category : #'tests - hard line breaks' }
FOCommonMarkSpecTest >> testHardLineBreaks2 [
	"CommonMark 0.31.2, example 637"
	self
		assertSource: #( 'foo\' 'baz' )
		rendersAs: #( '<p>foo<br />' 'baz</p>' )
]

{ #category : #'tests - hard line breaks' }
FOCommonMarkSpecTest >> testHardLineBreaks3 [
	"CommonMark 0.31.2, example 638"
	self
		assertSource: #( 'foo       ' 'baz' )
		rendersAs: #( '<p>foo<br />' 'baz</p>' )
]

{ #category : #'tests - soft line breaks' }
FOCommonMarkSpecTest >> testSoftLineBreaks1 [
	"CommonMark 0.31.2, example 651"
	self
		assertSource: #( 'foo' 'baz' )
		rendersAs: #( '<p>foo' 'baz</p>' )
]

{ #category : #'tests - soft line breaks' }
FOCommonMarkSpecTest >> testSoftLineBreaks2 [
	"CommonMark 0.31.2, example 652"
	self
		assertSource: #( 'foo ' ' baz' )
		rendersAs: #( '<p>foo' 'baz</p>' )
]

{ #category : #'tests - textual content' }
FOCommonMarkSpecTest >> testTextualContent1 [
	"CommonMark 0.31.2, example 653"
	self
		assertSource: #( 'hello $.;''there' )
		rendersAs: #( '<p>hello $.;''there</p>' )
]

{ #category : #'tests - textual content' }
FOCommonMarkSpecTest >> testTextualContent2 [
	"CommonMark 0.31.2, example 654"
	self
		assertSource: #( 'Foo χρῆν' )
		rendersAs: #( '<p>Foo χρῆν</p>' )
]

{ #category : #'tests - textual content' }
FOCommonMarkSpecTest >> testTextualContent3 [
	"CommonMark 0.31.2, example 655"
	self
		assertSource: #( 'Multiple     spaces' )
		rendersAs: #( '<p>Multiple     spaces</p>' )
]
