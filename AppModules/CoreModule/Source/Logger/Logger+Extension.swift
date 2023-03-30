//
//  CoreRouter.swift
//  CoreModule
//
//  Created by Maxim Ivanov on 16.12.2021.
//

extension Logger {

    public func debug(_ message: String) {
        log(message, level: .debug)
    }

    public func logWithContext(_ message: String,
                               level: LogLevel = .default,
                               file: String = #file,
                               function: String = #function,
                               line: Int = #line) {
        guard isDevelopment() else { return }

        log(message, level: level, file: file, function: function, line: line)
    }

    public func errorWithContext(_ error: Error,
                                 file: String = #file,
                                 function: String = #function,
                                 line: Int = #line) {
        guard isDevelopment() else { return }

        log("\(error)", level: .error, file: file, function: function, line: line)
    }

    public func logState<State>(actionName: String,
                                _ state: State,
                                file: String = #file,
                                function: String = #function,
                                line: Int = #line) {
        guard isDevelopment() else { return }
        let text = "\(actionName) result:\n\(state)"

        log(text, level: .default, file: file, function: function, line: line)
    }

    public func logSending<T>(_ object: T,
                              toModelStream modelStreamName: String,
                              file: String = #file,
                              function: String = #function,
                              line: Int = #line) {
        guard isDevelopment() else { return }
        let text = "Sending \(type(of: object)) = \(object) to the \(modelStreamName) model stream."

        log(text, level: .default, file: file, function: function, line: line)
    }

    public func logReceiving<T>(_ object: T,
                                fromModelStream modelStreamName: String,
                                file: String = #file,
                                function: String = #function,
                                line: Int = #line) {
        guard isDevelopment() else { return }
        let text = "Received \(type(of: object)) = \(object) from the \(modelStreamName) model stream."

        log(text, level: .default, file: file, function: function, line: line)
    }

    public func log(installedFeatureName: String) {
        debug("The \(installedFeatureName) feature has been installed.")
    }

    public func log(dismissedFeatureName: String) {
        debug("The \(dismissedFeatureName) feature has been dismissed.")
    }

    private func log(_ text: String, level: LogLevel, file: String, function: String, line: Int) {
        let description = "\((file as NSString).lastPathComponent) line:\(line) \(function)"

        log("\(text) -> \(description)", level: level)
    }
}
