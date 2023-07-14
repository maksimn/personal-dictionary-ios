//
//  Service+DI.swift
//  TodoList
//
//  Created by Maksim Ivanov on 10.07.2023.
//

import CoreModule

private let urlString = "https://d5dps3h13rv6902lp5c8.apigw.yandexcloud.net"

private func headers(_ token: String) -> [String: String] {
    [
        "Authorization": token,
        "Content-Type": "application/json"
    ]
}

extension TodoListServiceImp {

    init(token: String) {
        self.init(
            urlString: urlString,
            headers: headers(token),
            httpClient: HttpClientAdapterImpl()
        )
    }
}

extension SyncServiceImp {

    init(token: String) {
        self.init(
            urlString: urlString,
            headers: headers(token),
            httpClient: HttpClientAdapterImpl()
        )
    }
}
