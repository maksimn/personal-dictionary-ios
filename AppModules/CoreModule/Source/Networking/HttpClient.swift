//
//  HttpClient.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import Combine
import Foundation

public typealias RxHttpResponse = AnyPublisher<(response: HTTPURLResponse, data: Data), Error>

public struct Http {
    public let urlString: String
    public let method: String
    public let headers: [String: String]?
    public let body: Data?

    public init(urlString: String = "",
                method: String = "GET",
                headers: [String: String]? = nil,
                body: Data? = nil) {
        self.urlString = urlString
        self.method = method
        self.headers = headers
        self.body = body
    }
}

public protocol HttpClient {

    func send(_ http: Http) -> RxHttpResponse
}
