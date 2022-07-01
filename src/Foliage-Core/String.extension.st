Extension { #name : #String }

{ #category : #'*Foliage-Core' }
String >> asBeaconSignal [

	^ StringSignal new 
		message: self;
		yourself
]
