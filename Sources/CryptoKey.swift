//
//  CryptoKey.swift
//  Crypto
//
//  Created by Valery Bashkatov on 07.08.16.
//  Copyright © 2016 Valery Bashkatov. All rights reserved.
//

import Foundation
import Security

/// :nodoc:
public typealias CryptoKey = SecKey

/**
 The `CryptoKey` represents a type of the asymmetric cryptographic key. Same as `SecKey`.
 */
public extension CryptoKey {
    
    // MARK: - Properties
    
    /// The key in the form of data.
    public var data: NSData {
        let attributes: [String: AnyObject] = [
            (kSecClass as String): kSecClassKey,
            (kSecAttrApplicationTag as String): NSUUID().UUIDString,
            (kSecValueRef as String): self,
            (kSecReturnData as String): true
        ]
        
        var data: AnyObject?
        
        SecItemDelete(attributes)
        SecItemAdd(attributes, &data)
        SecItemDelete(attributes)
        
        return data as! NSData
    }
    
    /**
     A dictionary containing key's attributes.
     
     For a list of available values, see
     [Security Framework Reference](https://developer.apple.com/library/ios/documentation/Security/Reference/keychainservices/index.html#//apple_ref/doc/c_ref/kSecClassKey)
     */
    public var attributes: [String: AnyObject] {
        let attributes: [String: AnyObject] = [
            (kSecClass as String): kSecClassKey,
            (kSecAttrApplicationTag as String): NSUUID().UUIDString,
            (kSecValueRef as String): self,
            (kSecReturnAttributes as String): true
        ]
        
        var selfAttributes: AnyObject?
        
        SecItemDelete(attributes)
        SecItemAdd(attributes, &selfAttributes)
        SecItemDelete(attributes)
        
        return selfAttributes as! [String: AnyObject]
    }
    
    /*
     TODO:
    /**
     The key in PEM format.
     
     - seealso: [PEM Format Description](http://how2ssl.com/articles/working_with_pem_files/)
     */
    public var pem: String {
        var keyType = " "
        
        if let keyClass = self.attributes["kcls"] as? Int {
            switch keyClass {
            case 0:
                keyType = " PUBLIC "
                
            case 1:
                keyType = " PRIVATE "
                
            default:
                break
            }
        }
        
        let pem = "-----BEGIN" + keyType + "KEY-----\n" +
                  self.data.base64EncodedStringWithOptions(
                    [.Encoding64CharacterLineLength,
                     .EncodingEndLineWithLineFeed]) +
                  "\n-----END" + keyType + "KEY-----"
        
        return pem
    }
    
    // MARK: - Creating from Sources
    
    /**
     Creates `CryptoKey` from the data.
     
     - parameter data: The data used to create the key.
     - parameter algorithm: The algorithm type of the key. One of the `CryptoAlgoritm`'s values.
     - parameter isPublic: A Boolean value indicating the key is public or not.
     
     - returns: The `CryptoKey` object or nil if data is incorrect.
     */
    public static func create(fromData data: NSData, algorithm: CryptoAlgorithm, isPublic: Bool) -> CryptoKey? {
        let temporaryTag = NSUUID().UUIDString
        
        let attributes: [String: AnyObject] = [
            (kSecClass as String): kSecClassKey,
            (kSecAttrApplicationTag as String): temporaryTag,
            (kSecAttrKeyType as String): kSecAttrKeyTypeRSA,
            (kSecAttrKeyClass as String): isPublic ? kSecAttrKeyClassPublic: kSecAttrKeyClassPrivate,
            (kSecValueData as String): data,
            (kSecReturnRef as String): true
        ]
        
        var cryptoKey: AnyObject?
        
        SecItemDelete(attributes)
        SecItemAdd(attributes, &cryptoKey)
        SecItemDelete(attributes)
        
        return cryptoKey as! CryptoKey?
    }
    
    /**
     Creates `CryptoKey` from PEM formatted text.
     
     - parameter pem: The string in PEM format.
     - parameter algorithm: The algorithm type of the key. One of the `CryptoAlgoritm`'s values.
     - parameter isPublic: A Boolean value indicating the key is public or not.
     
     - returns: The `CryptoKey` object or nil if PEM text is incorrect.
     */
    public static func create(fromPEM pem: String, algorithm: CryptoAlgorithm, isPublic: Bool) -> CryptoKey? {
        var cryptoKey: AnyObject?
        let temporaryTag = NSUUID().UUIDString
        
        let lines = pem.componentsSeparatedByString("\n")
                       .filter {!$0.hasPrefix("-----BEGIN") && !$0.hasPrefix("-----END")}
                       .joinWithSeparator("")
        
        var data = NSData(base64EncodedString: lines, options: .IgnoreUnknownCharacters)!
        
        if isPublic {
            data = clearData(data)
        }
        
        let attributes: [String: AnyObject] = [
            (kSecClass as String): kSecClassKey,
            (kSecAttrApplicationTag as String): temporaryTag,
            (kSecAttrKeyType as String): kSecAttrKeyTypeRSA,
            (kSecAttrKeyClass as String): isPublic ? kSecAttrKeyClassPublic : kSecAttrKeyClassPrivate,
            (kSecValueData as String): data,
            (kSecReturnRef as String): true
        ]
        
        SecItemDelete(attributes)
        SecItemAdd(attributes, &cryptoKey)
        SecItemDelete(attributes)
        
        return cryptoKey as! CryptoKey?
    }
    
    private static func clearData(data: NSData) -> NSData {
        var dataBytes = [UInt8](count: data.length, repeatedValue: 0)
        
        data.getBytes(&dataBytes, length: data.length)
        
        var index = 0
        guard dataBytes[index] == 0x30 else {
            return data
        }
        
        index += 1
        if dataBytes[index] > 0x80 {
            index += Int(dataBytes[index]) - 0x80 + 1
        }
        else {
            index += 1
        }
        
        if Int(dataBytes[index]) == 0x02 {
            return data
        }
        
        guard Int(dataBytes[index]) == 0x30 else {
            return data
        }
        
        index += 15
        if dataBytes[index] != 0x03 {
            return data
        }
        
        index += 1
        if dataBytes[index] > 0x80 {
            index += Int(dataBytes[index]) - 0x80 + 1
        }
        else {
            index += 1
        }
        
        guard dataBytes[index] == 0 else {
            return data
        }
        
        index += 1
        dataBytes.removeRange(0..<index)
        
        return NSData(bytes: dataBytes, length: dataBytes.count)
    }
    */
}