//
//  HttpClient.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import Combine
import Foundation

public typealias RxHttpResponse = AnyPublisher<(response: HTTPURLResponse, data: Data), Error>

public protocol HttpClient {

    func send(_ http: Http) -> RxHttpResponse
}
