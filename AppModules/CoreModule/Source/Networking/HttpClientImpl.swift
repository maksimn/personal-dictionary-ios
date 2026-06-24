//
//  UrlSessionCoreService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import Foundation

public class HttpClientImpl: HttpClient {

    private let sessionConfiguration: URLSessionConfiguration

    private lazy var session: URLSession = {
        sessionConfiguration.timeoutIntervalForResource = 30.0
        return URLSession(configuration: sessionConfiguration)
    }()

    public init(sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.sessionConfiguration = sessionConfiguration
    }

    public func send(_ http: Http) async throws -> HttpResponseResult {
        let urlString = http.urlString
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)

        request.httpMethod = http.method
        request.httpBody = http.body

        http.headers?.forEach { (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }

        let (data, response) = try await session.data(for: request)

        guard let httpURLResponse = response as? HTTPURLResponse else {
            throw HttpClientError.nonHttpRequest
        }

        return HttpResponseResult(response: httpURLResponse, data: data)
    }

    enum HttpClientError: Error {
        case nonHttpRequest
    }
}
