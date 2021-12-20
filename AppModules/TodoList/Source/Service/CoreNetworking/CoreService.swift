//
//  CoreService.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 13.07.2021.
//

import Foundation

protocol CoreService {

    func set(urlString: String, httpMethod: String, headers: [String: String]?)

    func send(_ requestData: Data?, _ completion: @escaping (Result<Data, Error>) -> Void)
}
