//
//  HttpClientAdapter.swift
//  CoreModule
//
//  Created by Maxim Ivanov on 21.05.2023.
//

import Foundation

public struct HttpResponseResult {
    public let response: HTTPURLResponse
    public let data: Data

    public init(response: HTTPURLResponse, data: Data) {
        self.response = response
        self.data = data
    }
}

public protocol HttpClientAdapter {

    func send(_ http: Http) async throws -> HttpResponseResult
}
