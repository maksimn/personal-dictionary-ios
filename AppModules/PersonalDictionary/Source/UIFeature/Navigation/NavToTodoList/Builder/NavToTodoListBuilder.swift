//
//  NavToSearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import TodoList
import UIKit

/// Implementation of the "Navigation to Another Product/Application in the Superapp" feature builder.
final class NavToTodoListBuilder: ViewBuilder {

    private weak var rootViewController: UIViewController?
    private let bundle: Bundle

    init(rootViewController: UIViewController?,
         bundle: Bundle) {
        self.rootViewController = rootViewController
        self.bundle = bundle
    }

    /// Create the feature.
    /// - Returns: feature view.
    func build() -> UIView {
        let router = NavToTodoListRouter(
            rootViewController: rootViewController ?? UIViewController(),
            todoListBuilder: TodoList.AppBuilder()
        )

        return NavToTodoListView(
            routingButtonTitle: bundle.moduleLocalizedString("LS_TO_DO_LIST"),
            router: router,
            theme: Theme.data
        )
    }
}
