//
//  Crypto.swift
//  Crypto
//
//  Created by Valery Bashkatov on 07.08.16.
//  Copyright © 2016 Valery Bashkatov. All rights reserved.
//

import Foundation
import Security

/**
 The `Crypto` class contains a set of tools for working with cryptography.
 */
public class Crypto {
    
    // MARK: - Initialization
    
    /// :nodoc:
    private init() {}
    
    // MARK: - Keys Generation
    
    /**
     Generates asymmetric keys for a specified cryptographic algorithm.
     
     - parameter algorithm: The algorithm, for which asymmetric keys will be generated.
     
     - throws: The `CryptoError` if an error occurs.
     
     - returns: A tuple with asymmetric keys.
     */
    static public func generateKeyPair(algorithm: CryptoAlgorithm) throws -> (publicKey: CryptoKey, privateKey: CryptoKey) {
        var parameters = [String: AnyObject]()
        
        switch algorithm {
        case .rsa2048:
            parameters[kSecAttrKeyType as String] = kSecAttrKeyTypeRSA
            parameters[kSecAttrKeySizeInBits as String] = 2048
        }
        
        var publicKey: CryptoKey?
        var privateKey: CryptoKey?
        
        let generationStatus = SecKeyGeneratePair(parameters, &publicKey, &privateKey)
        
        guard generationStatus == errSecSuccess else {
            throw CryptoError(rawValue: Int(generationStatus))!
        }
        
        return (publicKey: publicKey!, privateKey: privateKey!)
    }
}