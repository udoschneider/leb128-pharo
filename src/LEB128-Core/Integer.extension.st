Extension { #name : #Integer }

{ #category : #'*LEB128-Core' }
Integer >> asSignedLeb128 [

	^ ByteArray streamContents: [ :stream | 
		  stream nextSignedLeb128IntegerPut: self ]
]

{ #category : #'*LEB128-Core' }
Integer >> asUnsignedLeb128 [

	^ ByteArray streamContents: [ :stream | 
		  stream nextUnsignedLeb128IntegerPut: self ]
]
