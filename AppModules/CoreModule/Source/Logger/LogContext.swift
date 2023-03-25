//
//  CoreRouter.swift
//  CoreModule
//
//  Created by Maxim Ivanov on 16.12.2021.
//

struct LogContext {

    let file: String
    let function: String
    let line: Int

    var description: String {
        "\((file as NSString).lastPathComponent) line:\(line) \(function)"
    }
}
