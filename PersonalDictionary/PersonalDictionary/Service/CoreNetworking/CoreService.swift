//
//  CoreService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import RxSwift

struct Http {
    let urlString: String
    let method: String
    let headers: [String: String]?
    let body: Data?
}

protocol CoreService {

    func send(_ http: Http) -> Single<Data>
}
