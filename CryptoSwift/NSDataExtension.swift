//
//  PGPDataExtension.swift
//  SwiftPGP
//
//  Created by Marcin Krzyzanowski on 05/07/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

extension NSMutableData {
    
    /** Convenient way to append bytes */
    internal func appendBytes(arrayOfBytes: [UInt8]) {
        self.appendBytes(arrayOfBytes, length: arrayOfBytes.count)
    }
    
}

extension NSData {

    /// Two octet checksum as defined in RFC-4880. Sum of all octets, mod 65536
    public func checksum() -> UInt16 {
        var s:UInt32 = 0
        var bytesArray = self.arrayOfBytes()
        for (var i = 0; i < bytesArray.count; i++) {
            s = s + UInt32(bytesArray[i])
        }
        s = s % 65536
        return UInt16(s)
    }
    
    public func md5() -> NSData? {
        guard let result = Hash.md5(self).calculate() else { return nil }
        return NSData.withBytes(result)
    }

    public func sha1() -> NSData? {
        guard let result = Hash.sha1(self).calculate() else { return nil }
        return NSData.withBytes(result)
    }

    public func sha224() -> NSData? {
        guard let result = Hash.sha224(self).calculate() else { return nil }
        return NSData.withBytes(result)
    }

    public func sha256() -> NSData? {
        guard let result = Hash.sha256(self).calculate() else { return nil }
        return NSData.withBytes(result)
    }

    public func sha384() -> NSData? {
        guard let result = Hash.sha384(self).calculate() else { return nil }
        return NSData.withBytes(result)
    }

    public func sha512() -> NSData? {
        guard let result = Hash.sha512(self).calculate() else { return nil }
        return NSData.withBytes(result)
    }

    public func crc32() -> NSData? {
        guard let result = Hash.crc32(self).calculate() else { return nil }
        return NSData.withBytes(result)
    }

    public func encrypt(cipher: Cipher) throws -> NSData? {
        let encrypted = try cipher.encrypt(self.arrayOfBytes())
        return NSData.withBytes(encrypted)
    }

    public func decrypt(cipher: Cipher) throws -> NSData? {
        let decrypted = try cipher.decrypt(self.arrayOfBytes())
        return NSData.withBytes(decrypted)
    }
    
    public func authenticate(authenticator: Authenticator) -> NSData? {
        if let result = authenticator.authenticate(self.arrayOfBytes()) {
            return NSData.withBytes(result)
        }
        return nil
    }
}

extension NSData {
    
    public func toHexString() -> String {
        return self.arrayOfBytes().toHexString()
    }
    
    public func arrayOfBytes() -> [UInt8] {
        let count = self.length / sizeof(UInt8)
        var bytesArray = [UInt8](count: count, repeatedValue: 0)
        self.getBytes(&bytesArray, length:count * sizeof(UInt8))
        return bytesArray
    }
    
    class public func withBytes(bytes: [UInt8]) -> NSData {
        return NSData(bytes: bytes, length: bytes.count)
    }
}

