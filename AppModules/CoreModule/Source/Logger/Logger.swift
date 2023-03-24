//
//  Logger.swift
//  CoreModule
//
//  Created by Maxim Ivanov on 24.03.2023.
//

public enum LogLevel {
    case debug
    case info
    case `default`
    case warn
    case error
}

public protocol Logger {

    func log(_ message: String, level: LogLevel)
}

extension Logger {

    public func log(_ message: String) {
        log(message, level: .default)
    }

    public func logState<State>(actionName: String, _ state: State) {
        log("\(actionName) result:\n\t\t\(type(of: state)): \(state)", level: .default)
    }

    public func logError(_ error: Error) {
        log("\(error)", level: .error)
    }

    public func log(installedFeatureName: String) {
        log("The \(installedFeatureName) feature has been installed.", level: .debug)
    }

    public func log(dismissedFeatureName: String) {
        log("The \(dismissedFeatureName) feature has been dismissed.", level: .debug)
    }

    public func logSending<T>(_ object: T, toModelStream modelStreamName: String) {
        log("Sending \(type(of: object)) = \(object) to the \(modelStreamName) model stream.", level: .default)
    }

    public func logReceiving<T>(_ object: T, fromModelStream modelStreamName: String) {
        log("Received \(type(of: object)) = \(object) from the \(modelStreamName) model stream.", level: .default)
    }
}
