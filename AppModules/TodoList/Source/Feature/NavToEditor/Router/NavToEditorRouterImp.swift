//
//  NavToSearchRouterImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

final class NavToEditorRouterImp: NavToEditorRouter {

    private weak var navigationController: UINavigationController?
    private let editorBuilder: EditorBuilder

    /// Инициализатор.
    /// - Parameters:
    ///  - navigationController: корневой navigation controller приложения.
    init(navigationController: UINavigationController?,
         editorBuilder: EditorBuilder) {
        self.navigationController = navigationController
        self.editorBuilder = editorBuilder
    }

    func navigate(with todoItem: TodoItem?) {
        let editorViewController = editorBuilder.build(initTodoItem: todoItem)

        editorViewController.modalPresentationStyle = .overFullScreen
        editorViewController.navigationItem.largeTitleDisplayMode = .never

        let otherNavigationController = UINavigationController(rootViewController: editorViewController)

        navigationController?.topViewController?.present(otherNavigationController, animated: true, completion: nil)
    }
}
