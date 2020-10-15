Class {
	#name : #BaselineOfFoliage,
	#superclass : #BaselineOf,
	#category : #BaselineOfFoliage
}

{ #category : #baselines }
BaselineOfFoliage >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		self neoJson: spec.
		spec 
			package: 'Foliage-Core' with: [
				spec requires: #('NeoJSON') ];
			package: 'Foliage-Core-Tests' with: [
				spec requires: #('Foliage-Core') ].
		spec 
			group: 'Core' with: #('Foliage-Core' );
			group: 'Tests' with: #('Foliage-Core-Tests' );
			group: 'default' with: #('Core' 'Tests') ]

]

{ #category : #baselines }
BaselineOfFoliage >> neoJson: spec [
	spec baseline: 'NeoJSON' with: [
		spec repository: 'github://svenvc/NeoJSON/repository'].
]
