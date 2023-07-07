//
//  AppBuilder.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 07.02.2023.
//

import ComposableArchitecture
import CoreData
import CoreModule
import Foundation
import UIKit

private let token = ""
private let featureName = "TodoList.App"

private let persistentContainerFactory = PersistentContainerFactoryImp(logger: LoggerImpl(category: featureName))
private let persistentContainer = persistentContainerFactory.persistentContainer()

public final class AppBuilder: ViewControllerBuilder {

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

    private func cache() -> TodoListCache { TodoListCacheImp(label: featureName) }

    private func deadCache() -> DeadCache { DeadCacheImp(label: featureName) }

    private func service() -> TodoListService { TodoListServiceImp(networking: networking()) }

    private func networking() -> TodoListNetworking {
        TodoListNetworkingImp(
            urlString: "https://d5dps3h13rv6902lp5c8.apigw.yandexcloud.net",
            headers: [
                "Authorization": token,
                "Content-Type": "application/json"
            ],
            httpClient: HttpClientImpl()
        )
    }
}

extension TodoListCacheImp {
    init(label: String) {
        self.init(cbTodoListCache: CBTodoListCacheImp(persistentContainer: persistentContainer))
    }
}

extension DeadCacheImp {
    init(label: String) {
        self.init(cbDeadCache: CBDeadCacheImp(persistentContainer: persistentContainer))
    }
}
