//
//  MainBuilderImp.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

public final class MainBuilderImp: MainBuilder {

    public init() { }

    public func build() -> UINavigationController {
        let navigationController = UINavigationController()
        let mainViewController = MainViewController(
            toggableItemListBuilder: ToggableItemListBuilderImp(navigationController: navigationController),
            navToItemEditorBuilder: NavToItemEditorBuilderImp(navigationController: navigationController),
            networkIndicatorBuilder: NetworkIndicatorBuilderImpl()
        )

        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.setViewControllers([mainViewController], animated: false)

        return navigationController
    }
}
