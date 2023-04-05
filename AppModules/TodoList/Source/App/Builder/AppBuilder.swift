//
//  AppBuilder.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 07.02.2023.
//

import ComposableArchitecture
import UIKit

final class AppBuilder: ViewControllerBuilder {

    func build() -> UIViewController {
        let effects = EffectsImp(
            cache: TodoListCacheImp(logger: logger),
            deadCache: DeadCacheImp(logger: logger),
            service: service,
            logger: logger
        )
        let reducer = App(effects: effects)._printChanges()
        let store = StoreOf<App>(
            initialState: App.State(),
            reducer: reducer
        )
        let mainScreenBuilder = MainScreenBuilder(store: store)
        let mainScreen = mainScreenBuilder.build()

        return mainScreen
    }

    private var service: TodoListService {
        let token = ""

        return TodoListServiceImp(
            networking: TodoListNetworkingImp(
                urlString: "https://d5dps3h13rv6902lp5c8.apigw.yandexcloud.net",
                headers: [
                    "Authorization": token,
                    "Content-Type": "application/json"
                ],
                httpClient: HttpClientImp(),
                coder: JsonCoderImp()
            )
        )
    }

    private var logger: Logger {
        LoggerImpl()
    }
}
