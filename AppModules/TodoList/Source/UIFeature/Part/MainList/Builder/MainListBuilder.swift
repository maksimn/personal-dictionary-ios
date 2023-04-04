//
//  MainListBuilder.swift
//  TodoList
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import ComposableArchitecture
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
        let navImage = UIImage(named: "icon-plus")!
        let todoCellImage = TodoCellImage(
            highPriorityIcon: UIImage(named: "high-priority")!,
            lowPriorityIcon: UIImage(named: "low-priority")!,
            completedCircle: UIImage(named: "finished-todo")!,
            highPriorityCircle: UIImage(named: "high-priority-circle")!,
            incompleteCircle: UIImage(named: "not-finished-todo")!,
            rightArrow: UIImage(named: "right-arrow")!,
            smallCalendar: UIImage(named: "small-calendar")!
        )
        let swipeImage = DataSourceParams.SwipeImage(
            inverseCompletedCircle: UIImage(named: "finished-todo-inverse")!,
            trashImage: UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!
        )
        let dataSourceParams = DataSourceParams(
            newCellPlaceholder: NSLocalizedString("LS_NEWTODO", comment: ""),
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
