//
//  Service+DI.swift
//  TodoList
//
//  Created by Maksim Ivanov on 10.07.2023.
//

import CoreModule

extension TodoListNetworkingImp {

    init(_ token: String) {
        self.init(
            urlString: "https://d5dps3h13rv6902lp5c8.apigw.yandexcloud.net",
            headers: [
                "Authorization": token,
                "Content-Type": "application/json"
            ],
            httpClient: HttpClientAdapterImpl()
        )
    }
}

extension TodoListServiceImp {

    init(_ token: String) {
        self.init(networking: TodoListNetworkingImp(token))
    }
}
