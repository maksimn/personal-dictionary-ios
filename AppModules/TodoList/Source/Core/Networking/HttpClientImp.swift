//
//  CoreService.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 26.06.2021.
//

import Foundation

class HttpClientImp: HttpClient {

    private lazy var session: URLSession = {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForResource = 30.0
        let session = URLSession(configuration: sessionConfiguration)
        return session
    }()

    func send(_ http: Http, _ completion: @escaping DataCallback) {
        guard let url = URL(string: http.urlString) else {
            return completion(.failure(HttpError.urlUndefined))
        }

        var request = URLRequest(url: url)

        request.httpMethod = http.method
        request.httpBody = http.body

        if let headers = http.headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }

        let sessionDataTask = session.dataTask(with: request) { (data, _, error) in
            if let error = error {
                return DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }

            DispatchQueue.main.async {
                completion(.success(data ?? Data()))
            }
        }

        sessionDataTask.resume()
    }

    enum HttpError: Error {
        case urlUndefined
    }
}
