//
//  MainListBuilder.swift
//  TodoList
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import ComposableArchitecture
import CoreModule
import UIKit

final class MainListBuilder: ViewControllerBuilder {

    private let store: StoreOf<MainList>
    private let networkIndicatorStore: StoreOf<NetworkIndicator>

    init(store: StoreOf<MainList>,
         networkIndicatorStore: StoreOf<NetworkIndicator>) {
        self.store = store
        self.networkIndicatorStore = networkIndicatorStore
    }

    func build() -> UIViewController {
        // Feature resources:
        let bundle = Bundle.module

        let navImage =  UIImage(named: "icon-plus", in: bundle, compatibleWith: nil)!
        let todoCellImage = TodoCellImage(
            highPriorityIcon: UIImage(named: "high-priority", in: bundle, compatibleWith: nil)!,
            lowPriorityIcon: UIImage(named: "low-priority", in: bundle, compatibleWith: nil)!,
            completedCircle: UIImage(named: "finished-todo", in: bundle, compatibleWith: nil)!,
            highPriorityCircle: UIImage(named: "high-priority-circle", in: bundle, compatibleWith: nil)!,
            incompleteCircle: UIImage(named: "not-finished-todo", in: bundle, compatibleWith: nil)!,
            rightArrow: UIImage(named: "right-arrow", in: bundle, compatibleWith: nil)!,
            smallCalendar: UIImage(named: "small-calendar", in: bundle, compatibleWith: nil)!
        )
        let swipeImage = DataSourceParams.SwipeImage(
            inverseCompletedCircle: UIImage(named: "finished-todo-inverse", in: bundle, compatibleWith: nil)!,
            trashImage: UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!
        )
        let dataSourceParams = DataSourceParams(
            newCellPlaceholder: bundle.moduleLocalizedString("LS_NEWTODO"),
            todoCellImage: todoCellImage,
            swipeImage: swipeImage
        )
        let params = MainListViewParams(navImage: navImage, dataSourceParams: dataSourceParams)

        // Stores:
        let keyboardStore = store.scope(state: \.keyboard, action: MainList.Action.keyboard)

        // View controller:
        let mainListViewController = MainListViewController(
            params: params,
            theme: Theme.data,
            store: store,
            networkIndicatorStore: networkIndicatorStore,
            keyboardUDFBuilder: KeyboardUDFBuilder(store: keyboardStore)
        )

        return mainListViewController
    }
}
