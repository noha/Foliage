Class {
	#name : #FOServer,
	#superclass : #Object,
	#instVars : [
		'server',
		'baseDirectory'
	],
	#category : #'Foliage-Server'
}

{ #category : #accessing }
FOServer class >> start [
	<script>

	^ self new start
]

{ #category : #accessing }
FOServer class >> stop [
	<script>
	
	^ ZnServer default stop
]

{ #category : #accessing }
FOServer >> baseDirectory [

	^ baseDirectory ifNil: [ baseDirectory := 'generated' asFileReference ]
]

{ #category : #accessing }
FOServer >> baseDirectory: aReference [

	baseDirectory := aReference
]

{ #category : #accessing }
FOServer >> baseUrl [

	^ ''
]

{ #category : #accessing }
FOServer >> port [

	^ 7070
]

{ #category : #'start/stop' }
FOServer >> start [
	<script: 'self new start'>

	(ZnServer defaultOn: self port) start.
	ZnServer default delegate: ((FOStaticFileServerDelegate new)
		prefixFromString: self baseUrl;
		directory: self baseDirectory;
	 	yourself)
]
