//
//  MainBuilderImp.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

public final class MainBuilderImp: MainBuilder {

    public init() { }

    public func build() -> UIViewController {
        let navigationController = UINavigationController()
        let mainViewController = MainViewController(
            mainTitle: "Мои дела",
            richTodoListBuilder: RichTodoListBuilderImp(navigationController: navigationController),
            navToEditorBuilder: NavToEditorBuilderImp(navigationController: navigationController),
            networkIndicatorBuilder: NetworkIndicatorBuilderImpl()
        )

        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.setViewControllers([mainViewController], animated: false)

        return navigationController
    }
}
