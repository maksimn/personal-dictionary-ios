//
//  NavToItemEditorBuilderImp.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

final class NavToItemEditorBuilderImp: NavToItemEditorBuilder {

    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView {
        let itemEditorBuilder = TodoEditorBuilderImpl()
        let router = NavToItemEditorRouterImp(
            navigationController: navigationController,
            todoEditorBuilder: itemEditorBuilder
        )
        let view = NavToItemEditorView(
            navigationImage: Images.plusIcon,
            router: router
        )

        return view
    }
}
