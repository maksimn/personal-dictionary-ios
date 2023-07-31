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
            service: TodoListServiceImp(token: syncConfig.token),
            tombstones: DeletedTodoCache(label: featureName),
            dirtyStateStatus: DirtyStateStatusImp(label: featureName),
            currentDate: { Date() }
        )._printChanges()
        let store = Store(initialState: App.State(sync: .init(delay: syncConfig.minDelay))) { app }
        let mainScreenBuilder = MainScreenBuilder(store: store)
        let mainScreen = mainScreenBuilder.build()

        store.send(.start)

        return mainScreen
    }
}
