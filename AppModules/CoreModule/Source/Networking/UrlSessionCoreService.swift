//
//  UrlSessionCoreService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import RxCocoa
import RxSwift

public class UrlSessionCoreService: CoreService {

    private let sessionConfiguration: URLSessionConfiguration

    private lazy var session: URLSession = {
        sessionConfiguration.timeoutIntervalForResource = 30.0
        let session = URLSession(configuration: sessionConfiguration)
        return session
    }()

    public init(sessionConfiguration: URLSessionConfiguration) {
        self.sessionConfiguration = sessionConfiguration
    }

    public func send(_ http: Http) -> Single<Data> {
        Single<Data>.create { observer in
            let urlString = http.urlString
            guard let url = URL(string: urlString) else {
                observer(.error(HttpError.urlUndefined))
                return Disposables.create {}
            }

            var request = URLRequest(url: url)

            request.httpMethod = http.method
            request.httpBody = http.body

            if let headers = http.headers {
                for (key, value) in headers {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }

            return self.session.rx.response(request: request)
                .subscribe(
                    onNext: { observer(.success($1)) },
                    onError: { observer(.error($0)) }
                )
        }
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
        .observeOn(MainScheduler.instance)
    }

    enum HttpError: Error {
        case urlUndefined
    }
}
