//
//  CoreRouter.swift
//  CoreModule
//
//  Created by Maxim Ivanov on 16.12.2021.
//

extension Logger {

    public func log(_ message: String,
                    shouldLogContext: Bool = true,
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line) {
        guard isDevelopment() else { return }

        log(message, level: .default, shouldLogContext: shouldLogContext, file: file, function: function, line: line)
    }

    public func logState<State>(actionName: String,
                                _ state: State,
                                shouldLogContext: Bool = true,
                                file: String = #file,
                                function: String = #function,
                                line: Int = #line) {
        guard isDevelopment() else { return }
        let text = "\(actionName) result:\n\(state)"

        log(text, level: .default, shouldLogContext: shouldLogContext, file: file, function: function, line: line)
    }

    public func logError(_ error: Error, shouldLogContext: Bool = true, file: String = #file,
                         function: String = #function, line: Int = #line) {
        guard isDevelopment() else { return }

        log("\(error)", level: .error, shouldLogContext: shouldLogContext, file: file, function: function, line: line)
    }

    public func logSending<T>(_ object: T,
                              toModelStream modelStreamName: String,
                              shouldLogContext: Bool = true,
                              file: String = #file,
                              function: String = #function,
                              line: Int = #line) {
        guard isDevelopment() else { return }
        let text = "Sending \(type(of: object)) = \(object) to the \(modelStreamName) model stream."

        log(text, level: .default, shouldLogContext: shouldLogContext, file: file, function: function, line: line)
    }

    public func logReceiving<T>(_ object: T,
                                fromModelStream modelStreamName: String,
                                shouldLogContext: Bool = true,
                                file: String = #file,
                                function: String = #function,
                                line: Int = #line) {
        guard isDevelopment() else { return }
        let text = "Received \(type(of: object)) = \(object) from the \(modelStreamName) model stream."

        log(text, level: .default, shouldLogContext: shouldLogContext, file: file, function: function, line: line)
    }

    public func log(installedFeatureName: String) {
        log("The \(installedFeatureName) feature has been installed.", level: .debug)
    }

    public func log(dismissedFeatureName: String) {
        log("The \(dismissedFeatureName) feature has been dismissed.", level: .debug)
    }

    private func log(_ text: String,
                     level: LogLevel,
                     shouldLogContext: Bool,
                     file: String,
                     function: String,
                     line: Int) {
        if shouldLogContext {
            let context = LogContext(file: file, function: function, line: line)

            return log("\(text) -> \(context.description)", level: level)
        }

        log(text, level: level)
    }
}
