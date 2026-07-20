Class {
	#name : #BaselineOfFoliage,
	#superclass : #BaselineOf,
	#category : #BaselineOfFoliage
}

{ #category : #baselines }
BaselineOfFoliage >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		self
			mustache: spec;
			soup: spec;
			zinc: spec.

		spec package: 'Foliage-Frontmatter' with: [  ].
		spec package: 'Foliage-Frontmatter-Tests' with: [
			spec requires: #('Foliage-Frontmatter') ].
		spec package: 'Foliage-Markdown' with: [  ].
		spec package: 'Foliage-Markdown-Tests' with: [
			spec requires: #('Foliage-Markdown') ].
		spec package: 'Foliage-Core' with: [
			spec requires: #('Foliage-Frontmatter' 'Foliage-Markdown' 'Mustache' 'Soup' 'ZincHTTPComponents') ].
		spec package: 'Foliage-Core-Tests' with: [
			spec requires: #('Foliage-Core') ].
		spec package: 'Foliage-Publisher' with: [
			spec requires: #('Foliage-Core') ].
		spec package: 'Foliage-Server' with: [
			spec requires: #('Foliage-Core') ].

		spec
			group: 'tests' with: #('Foliage-Frontmatter-Tests' 'Foliage-Markdown-Tests' 'Foliage-Core-Tests');
			group: 'default' with: #('Foliage-Frontmatter' 'Foliage-Markdown' 'Foliage-Core' 'Foliage-Publisher' 'Foliage-Server' 'tests') ]
]

{ #category : #baselines }
BaselineOfFoliage >> mustache: spec [
	spec baseline: 'Mustache' with: [
		spec
			repository: 'github://noha/Mustache:12bfb80b5acb76fca1aec69c15d28d44026e6fd0/repository';
			loads: #('Core')].
]

{ #category : #baselines }
BaselineOfFoliage >> soup: spec [
	spec baseline: 'Soup' with: [
		spec
			repository: 'github://pharo-contributions/Soup';
			loads: #('Core')].
]

{ #category : #baselines }
BaselineOfFoliage >> zinc: spec [
	spec baseline: 'ZincHTTPComponents' with: [
		spec
			repository: 'github://svenvc/zinc/repository';
			loads: #('Zinc-HTTP-Examples')].
]
