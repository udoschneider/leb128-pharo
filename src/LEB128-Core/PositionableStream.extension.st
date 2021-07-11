Extension { #name : #PositionableStream }

{ #category : #'*LEB128-Core' }
PositionableStream >> nextSignedLeb128Integer [

	| result shift byte |
	result := 0.
	shift := 0.
	[ 
	byte := self next.
	result := result bitOr: (byte bitAnd: 16r7F) << shift.
	shift := shift + 7.
	(byte bitAnd: 16r80) ~= 0 ] whileTrue.
	(byte bitAnd: 16r40) ~= 0 ifTrue: [ 
		result := (1 << shift - 1 bitXor: result) bitInvert ].
	^ result
]

{ #category : #'*LEB128-Core' }
PositionableStream >> nextSignedLeb128IntegerPut: anInteger [

	| value more byte |
	value := anInteger.
	more := true.
	[ more ] whileTrue: [ 
		byte := value bitAnd: 16r7f.
		value := value >> 7.
		((value = 0 and: [ (byte bitAnd: 16r40) = 0 ]) or: [ 
			 value = -1 and: [ (byte bitAnd: 16r40) ~= 0 ] ])
			ifTrue: [ more := false ]
			ifFalse: [ byte := byte bitOr: 16r80 ].
		self nextPut: byte ]
]

{ #category : #'*LEB128-Core' }
PositionableStream >> nextUnsignedLeb128Integer [

	| result shift byte |
	result := 0.
	shift := 0.
	[ 
	byte := self next.
	result := result bitOr: (byte bitAnd: 16r7F) << shift.
	shift := shift + 7.
	(byte bitAnd: 16r80) ~= 0 ] whileTrue.
	^ result
]

{ #category : #'*LEB128-Core' }
PositionableStream >> nextUnsignedLeb128IntegerPut: anInteger [

	| byte value |
	value := anInteger.
	[ 
	byte := value bitAnd: 16r7F.
	value := value >> 7.
	value ~= 0 ifTrue: [ byte := byte bitOr: 16r80 ].
	self nextPut: byte.
	value ~= 0 ] whileTrue
]
