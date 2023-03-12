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

    public func logState<State>(actionName: String, _ state: State) {
        log("\(actionName) result:\n\t\t\(type(of: state)): \(state)")
    }

    public func logError(_ error: Error, source: String) {
        log("\n\t\tError: \(error) \n\t\tfrom \(source).")
    }

    public func logFeatureInstallation() {
        log("The feature has been installed.")
    }

    public func logFeatureDismission() {
        log("The feature has been dismissed.")
    }
}
