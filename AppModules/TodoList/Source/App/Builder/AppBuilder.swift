//
//  AppBuilder.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 07.02.2023.
//

import ComposableArchitecture
import CoreModule
import UIKit

public final class AppBuilder: ViewControllerBuilder {

    public init() { }

    public func build() -> UIViewController {
        let token = ""
        let featureName = "TodoList.App"
        let syncConfig = SyncConfig(token: token, minDelay: 2)

        let app = App(
            syncConfig: syncConfig,
            cache: TodoListCacheImp(label: featureName),
            deadCache: DeadCacheImp(label: featureName),
            service: TodoListServiceImp(token),
            currentDate: { Date() }
        )._printChanges()
        let store = StoreOf<App>(
            initialState: App.State(sync: .init(delay: syncConfig.minDelay)),
            reducer: app
        )
        let mainScreenBuilder = MainScreenBuilder(store: store)
        let mainScreen = mainScreenBuilder.build()

        return mainScreen
    }
}
