//
//  UrlSessionCoreService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import RxCocoa
import RxSwift

public class HttpClientImpl: HttpClient {

    private let sessionConfiguration: URLSessionConfiguration

    private lazy var session: URLSession = {
        sessionConfiguration.timeoutIntervalForResource = 30.0
        return URLSession(configuration: sessionConfiguration)
    }()

    public init(sessionConfiguration: URLSessionConfiguration) {
        self.sessionConfiguration = sessionConfiguration
        URLSession.rx.shouldLogRequest = { _ in false }
    }

    public func send(_ http: Http) -> RxHttpResponse {
        let urlString = http.urlString
        guard let url = URL(string: urlString) else { return .error(HttpError.urlUndefined) }
        var request = URLRequest(url: url)

        request.httpMethod = http.method
        request.httpBody = http.body

        if let headers = http.headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }

        return session.rx.response(request: request)
    }

    enum HttpError: Error {
        case urlUndefined
    }
}
