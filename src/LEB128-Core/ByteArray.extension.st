Extension { #name : #ByteArray }

{ #category : #'*LEB128-Core' }
ByteArray >> signedLeb128Integer [

	^ self signedLeb128IntegerAt: 1
]

{ #category : #'*LEB128-Core' }
ByteArray >> signedLeb128IntegerAt: index [

	^ self readStream
		  next: index - 1;
		  nextSignedLeb128Integer
]

{ #category : #'*LEB128-Core' }
ByteArray >> signedLeb128IntegerAt: index put: anInteger [

	| bytes |
	bytes := anInteger asSignedLeb128.
	^ self replaceFrom: index to: index + bytes size - 1 with: bytes
]

{ #category : #'*LEB128-Core' }
ByteArray >> signedLeb128IntegerPut: anInteger [

	^ self signedLeb128IntegerAt: 1 put: anInteger
]

{ #category : #'*LEB128-Core' }
ByteArray >> unsignedLeb128Integer [

	^ self unsignedLeb128IntegerAt: 1
]

{ #category : #'*LEB128-Core' }
ByteArray >> unsignedLeb128IntegerAt: index [

	^ self readStream
		  next: index - 1;
		  nextUnsignedLeb128Integer
]

{ #category : #'*LEB128-Core' }
ByteArray >> unsignedLeb128IntegerAt: index put: anInteger [

	| bytes |
	bytes := anInteger asUnsignedLeb128.
	^ self replaceFrom: index to: index + bytes size - 1 with: bytes
]

{ #category : #'*LEB128-Core' }
ByteArray >> unsignedLeb128IntegerPut: anInteger [

	^ self unsignedLeb128IntegerAt: 1 put: anInteger
]
