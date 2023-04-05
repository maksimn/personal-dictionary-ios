//
//  UrlSessionCoreService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import Combine
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

    public func send(_ http: Http) -> RxHttpResponse {
        let urlString = http.urlString
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)

        request.httpMethod = http.method
        request.httpBody = http.body

        http.headers?.forEach { (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }

        return session.dataTaskPublisher(for: request)
            .tryMap { value in
                guard let httpURLResponse = value.response as? HTTPURLResponse else {
                    throw HttpClientError.nonHttpRequest
                }

                return (response: httpURLResponse, data: value.data)
            }
            .eraseToAnyPublisher()
    }

    enum HttpClientError: Error {
        case nonHttpRequest
    }
}
