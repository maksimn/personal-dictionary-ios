//
//  CoreService.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 26.06.2021.
//

import Foundation

class URLSessionCoreService: CoreService {

    private var urlString: String?
    private var httpMethod: String?
    private var headers: [String: String]?

    private lazy var session: URLSession = {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForResource = 30.0
        let session = URLSession(configuration: sessionConfiguration)
        return session
    }()

    func set(urlString: String, httpMethod: String, headers: [String: String]?) {
        self.urlString = urlString
        self.httpMethod = httpMethod
        self.headers = headers
    }

    func send(_ requestData: Data?, _ completion: @escaping (Result<Data, Error>) -> Void) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            return completion(.failure(HttpError.urlUndefined))
        }

        var request = URLRequest(url: url)

        request.httpMethod = httpMethod
        request.httpBody = requestData

        if let headers = headers {
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
