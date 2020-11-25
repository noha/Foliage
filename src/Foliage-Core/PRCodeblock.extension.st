Extension { #name : #PRCodeblock }

{ #category : #'*Foliage-Core' }
PRCodeblock >> replaceTabs [
	text := text copyReplaceAll: Character tab asString with: '    '
]
