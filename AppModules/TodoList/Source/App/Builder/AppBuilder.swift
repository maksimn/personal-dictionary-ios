//
//  AppBuilder.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 07.02.2023.
//

import ComposableArchitecture
import CoreModule
import Foundation
import UIKit

public final class AppBuilder: ViewControllerBuilder {

    private func logger() -> Logger { LoggerImpl(category: "TodoList.App") }

    private func cache() -> TodoListCache { TodoListCacheImp(logger: logger()) }

    private func deadCache() -> DeadCache { DeadCacheImp(logger: logger()) }

    private func service() -> TodoListService {
        let token = ""

        return TodoListServiceImp(
            networking: TodoListNetworkingImp(
                urlString: "https://d5dps3h13rv6902lp5c8.apigw.yandexcloud.net",
                headers: [
                    "Authorization": token,
                    "Content-Type": "application/json"
                ],
                httpClient: HttpClientImpl()
            )
        )
    }

    public init() { }

    public func build() -> UIViewController {
        let app = App(
            cache: cache(),
            deadCache: deadCache(),
            service: service(),
            currentDate: { Date() }
        )._printChanges()
        let store = StoreOf<App>(
            initialState: App.State(),
            reducer: app
        )
        let mainScreenBuilder = MainScreenBuilder(store: store)
        let mainScreen = mainScreenBuilder.build()

        return mainScreen
    }
}
