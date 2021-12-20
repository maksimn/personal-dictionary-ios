//
//  CoreModuleParams.swift
//  SuperList
//
//  Created by Maxim Ivanov on 20.12.2021.
//

import Foundation

public struct CoreModuleParams {

    public let isLoggingEnabled: Bool
    public let urlSessionConfiguration: URLSessionConfiguration

    public init(isLoggingEnabled: Bool,
                urlSessionConfiguration: URLSessionConfiguration) {
        self.isLoggingEnabled = isLoggingEnabled
        self.urlSessionConfiguration = urlSessionConfiguration
    }
}
