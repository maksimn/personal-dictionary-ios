//
//  CoreService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import Foundation

protocol CoreService {

    func set(urlString: String, httpMethod: String, headers: [String: String]?)

    func send(_ requestData: Data?, _ completion: @escaping (Result<Data, Error>) -> Void)
}
