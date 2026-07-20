Class {
	#name : #BaselineOfFoliage,
	#superclass : #BaselineOf,
	#category : #BaselineOfFoliage
}

{ #category : #baselines }
BaselineOfFoliage >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec package: 'Foliage-Frontmatter' with: [  ].
		spec package: 'Foliage-Frontmatter-Tests' with: [
			spec requires: #('Foliage-Frontmatter') ].
		spec package: 'Foliage-Markdown' with: [  ].
		spec package: 'Foliage-Markdown-Tests' with: [
			spec requires: #('Foliage-Markdown') ].

		spec
			group: 'tests' with: #('Foliage-Frontmatter-Tests' 'Foliage-Markdown-Tests');
			group: 'default' with: #('Foliage-Frontmatter' 'Foliage-Markdown' 'tests') ]
]
