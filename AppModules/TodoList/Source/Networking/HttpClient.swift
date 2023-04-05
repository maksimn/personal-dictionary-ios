//
//  CoreService.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 13.07.2021.
//

import Foundation

struct Http {
    let urlString: String
    let method: String
    let headers: [String: String]?
    let body: Data?

    init(
        urlString: String,
        method: String,
        headers: [String: String]?,
        body: Data? = nil
    ) {
        self.urlString = urlString
        self.method = method
        self.headers = headers
        self.body = body
    }
}

protocol HttpClient {

    func send(_ http: Http, _ completion: @escaping DataCallback)
}
