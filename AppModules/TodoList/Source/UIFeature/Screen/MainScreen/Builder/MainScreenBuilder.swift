//
//  AppBuilderImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 10.08.2022.
//

import ComposableArchitecture
import UIKit

final class MainScreenBuilder: ViewControllerBuilder {

    private let store: StoreOf<App>

    init(store: StoreOf<App>) {
        self.store = store
    }

    func build() -> UIViewController {
        let mainTitle = NSLocalizedString("LS_MAIN_SCREEN_TITLE", comment: "")

        let mainListStore = store.scope(state: \.mainList, action: App.Action.mainList)
        let counterStore = store.actionless.scope(state: \.mainList.completedTodoCount)
        let networkIndicatorStore = store.scope(state: \.networkIndicator, action: App.Action.networkIndicator)
        let showButtonStore = mainListStore.scope(
            state: { state in
                ShowButton.State(
                    mode: state.areCompletedTodosVisible ? .hide : .show,
                    isEnabled: state.completedTodoCount > 0
                )
            },
            action: MainList.Action.showButton
        )

        let mainScreen = MainScreen(
            mainTitle: mainTitle,
            theme: Theme.data,
            counterBuilder: CounterBuilder(store: counterStore),
            showButtonBuilder: ShowButtonBuilder(store: showButtonStore),
            networkIndicatorBuilder: NetworkIndicatorBuilder(store: networkIndicatorStore),
            mainListBuilder: MainListBuilder(store: mainListStore, networkIndicatorStore: networkIndicatorStore)
        )
        let navigationController = UINavigationController(rootViewController: mainScreen)

        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.navigationBar.prefersLargeTitles = true

        return navigationController
    }
}
