//
//  HttpClient.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
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

public protocol HttpClient {

    func send(_ http: Http) async throws -> HttpResponseResult
}
