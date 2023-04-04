//
//  NavToEditorBuilderImp.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

final class NavToEditorBuilderImp: NavToEditorBuilder {

    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView {
        let editorBuilder = EditorBuilderImpl()
        let router = NavToEditorRouterImp(
            navigationController: navigationController,
            editorBuilder: editorBuilder
        )
        let view = NavToEditorView(
            navigationImage: UIImage(named: "icon-plus", in: Bundle.module, with: nil)!,
            router: router
        )

        return view
    }
}
