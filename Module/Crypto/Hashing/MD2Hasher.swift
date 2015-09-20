//
//  MD2Hasher.swift
//  Jelly
//
//  Created by Steve Streza on 19.9.15.
//  Copyright © 2015 Lunar Guard. All rights reserved.
//

public class MD2Hasher: Hasher {
	public var hashLength = Int(CC_MD2_DIGEST_LENGTH)
	
	private let context = UnsafeMutablePointer<CC_MD2_CTX>.alloc(1)
	
	public required init() {
		CC_MD2_Init(context)
	}
	
	public func update(data: Data) {
		CC_MD2_Update(context, data.unsafeVoidPointer, CC_LONG(data.bytes.count))
	}
	
	public func finish() -> Data {
		var digest = Array<UInt8>(count: self.hashLength, repeatedValue:0)
		CC_MD2_Final(&digest, context)
		return Data(byteArray: digest)
	}
}

public extension Pullable where Self.Sequence: DataConvertible {
	var MD2Stream: CryptoDigestStream<Self, MD2Hasher> {
		get {
			return CryptoDigestStream(stream: self, hasher: MD2Hasher())
		}
	}
}

public extension DataConvertible {
	var MD2: Data? {
		get {
			return self.stream.MD2Stream.drain()
		}
	}
}

public extension File {
	var MD2: Data? {
		get {
			return self.readPullStream?.MD2Stream.drain()
		}
	}
}