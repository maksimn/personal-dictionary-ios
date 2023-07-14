//
//  Http.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 15.07.2023.
//

import Foundation

public struct Http {
    public let urlString: String
    public let method: String
    public let headers: [String: String]?
    public let body: Data?

    public init(urlString: String = "",
                method: String = "GET",
                headers: [String: String]? = nil,
                body: Data? = nil) {
        self.urlString = urlString
        self.method = method
        self.headers = headers
        self.body = body
    }

    func setBody(_ data: Data) -> Http {
        .init(urlString: urlString, method: method, headers: headers, body: data)
    }
}
