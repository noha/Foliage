Class {
	#name : #FOSeriesRenderContext,
	#superclass : #FORenderContext,
	#instVars : [
		'series'
	],
	#category : #'Foliage-Core-Blog'
}

{ #category : #accessing }
FOSeriesRenderContext >> abstract [
	^ series abstract
]

{ #category : #accessing }
FOSeriesRenderContext >> layout [
	^ series abstractLayout
]

{ #category : #accessing }
FOSeriesRenderContext >> partCount [
	^ series partCount
]

{ #category : #accessing }
FOSeriesRenderContext >> pathString [
	^ series pathString
]

{ #category : #accessing }
FOSeriesRenderContext >> series [
	^ series
]

{ #category : #accessing }
FOSeriesRenderContext >> series: aFOSeries [
	series := aFOSeries
]

{ #category : #accessing }
FOSeriesRenderContext >> title [
	^ series title
]
