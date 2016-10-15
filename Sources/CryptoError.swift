//
//  CryptoError.swift
//  Crypto
//
//  Created by Valery Bashkatov on 07.08.16.
//  Copyright © 2016 Valery Bashkatov. All rights reserved.
//

import Foundation

/**
 The `CryptoError` represents `Crypto`'s errors.
 */
public enum CryptoError: Int, ErrorType, CustomStringConvertible {
    
    /// The function or operation is not implemented.
    case unimplementedFunction = -4
    
    /// One or more parameters passed to a function were not valid.
    case invalidParameter = -50
    
    /// Failed to allocate memory.
    case memoryAllocationFailed = -108
    
    /// No keychain is available.
    case keychainUnavailable = -25291
    
    /// An item with the same primary key attributes already exists.
    case duplicateKey = -25299
    
    /// The item cannot be found.
    case keyNotFound = -25300
    
    /// Interaction with the user is required in order to grant access or process a request; however, user interaction with the Security Server has been disabled by the program.
    case interactionNotAllowed = -25308
    
    /// Unable to decode the provided data.
    case dataDecodeError = -26275
    
    /// Authorization or authentication failed.
    case authFailed = -25293
    
    /// Text description of the error.
    public var description: String {
        let text: String
        
        switch self.rawValue {
        case -4: text = "The function or operation is not implemented"
        case -50: text = "One or more parameters passed to a function were not valid"
        case -108: text = "Failed to allocate memory"
        case -25291: text = "No keychain is available"
        case -25299: text = "An item with the same primary key attributes already exists"
        case -25300: text = "The item cannot be found"
        case -25308: text = "Interaction with the user is required in order to grant access or process a request; however, user interaction with the Security Server has been disabled by the program."
        case -26275: text = "Unable to decode the provided data"
        case -25293: text = "Authorization or authentication failed"
        default: text = "Unknown error"
        }
        
        return "CryptoError (\(self.rawValue)): \(text)."
    }
}