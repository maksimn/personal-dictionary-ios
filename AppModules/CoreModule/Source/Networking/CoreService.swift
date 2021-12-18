//
//  CoreService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import RxSwift

public struct Http {
    let urlString: String
    let method: String
    let headers: [String: String]?
    let body: Data?

    public init(urlString: String,
                method: String,
                headers: [String: String]?,
                body: Data?) {
        self.urlString = urlString
        self.method = method
        self.headers = headers
        self.body = body
    }
}

public protocol CoreService {

    func send(_ http: Http) -> Single<Data>
}
