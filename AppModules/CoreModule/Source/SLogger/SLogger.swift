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

    public func log(installedFeatureName: String) {
        log("The \(installedFeatureName) feature has been installed.")
    }

    public func log(dismissedFeatureName: String) {
        log("The \(dismissedFeatureName) feature has been dismissed.")
    }

    public func logSending<T>(_ object: T, toModelStream modelStreamName: String) {
        log("Sending \(type(of: object)) = \(object) to the \(modelStreamName) model stream.")
    }

    public func logReceiving<T>(_ object: T, fromModelStream modelStreamName: String) {
        log("Received \(type(of: object)) = \(object) from the \(modelStreamName) model stream.")
    }
}
