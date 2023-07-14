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

extension HttpClientAdapter {

    public func sendAndDecode<Output: Decodable>(_ http: Http) async throws -> Output {
        let httpResponse = try await send(http)

        return try JSONDecoder().decode(Output.self, from: httpResponse.data)
    }

    public func sendAndDecode<Body: Encodable, Output: Decodable>(_ http: Http, _ body: Body) async throws -> Output {
        let body = try JSONEncoder().encode(body)

        return try await sendAndDecode(http.setBody(body))
    }
}
