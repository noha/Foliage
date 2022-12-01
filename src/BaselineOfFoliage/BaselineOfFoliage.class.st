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
			neoJson: spec;
			soup: spec;
			zinc: spec;
			microdown: spec.

		spec 
			package: 'Foliage-Core' with: [
				spec requires: #('NeoJSON' 'Mustache' 'Soup' 'Microdown') ];
			package: 'Foliage-Publisher' with: [
				spec requires: #('Foliage-Core') ];
			package: 'Foliage-Server' with: [
				spec requires: #('Foliage-Core') ];
			package: 'Foliage-Core-Tests' with: [
				spec requires: #('Foliage-Core') ].
		spec 
			group: 'Core' with: #('Foliage-Core' );
			group: 'Publisher' with: #('Core' 'Foliage-Publisher');
			group: 'Tests' with: #('Foliage-Core-Tests' );
			group: 'default' with: #('Core' 'Tests');
			group: 'development' with: #('Core' 'Tests' 'ZincHTTPComponents') ]

]

{ #category : #baselines }
BaselineOfFoliage >> microdown: spec [

	spec baseline: 'Microdown' with: [
		spec 
			repository: 'github://estebanlm/Microdown:v1-mac/src';
			loads: #('Macrodown') ]
]

{ #category : #baselines }
BaselineOfFoliage >> mustache: spec [
	spec baseline: 'Mustache' with: [
		spec 
			repository: 'github://noha/Mustache/repository';
			loads: #('Core')].
]

{ #category : #baselines }
BaselineOfFoliage >> neoJson: spec [
	spec baseline: 'NeoJSON' with: [
		spec repository: 'github://svenvc/NeoJSON/repository'].
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
