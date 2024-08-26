//
//  File.swift
//  
//
//  Created by Didier Brun on 26/08/2024.
//

public enum ModuleIAPError:Error {
    case loadingFailed
    case verificationFailed
    case userCancelled
    case pending
    case unknown
}
