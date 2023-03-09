//
//  Logger.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

public protocol SLogger {

    func log(_ message: String)
}

extension SLogger {

    public func logError(_ error: Error, source: String) {
        log("\n\t\tError: \(error) \n\t\tfrom \(source).")
    }
}
