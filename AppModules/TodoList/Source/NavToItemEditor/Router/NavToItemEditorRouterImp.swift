//
//  NavToSearchRouterImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

final class NavToItemEditorRouterImp: NavToItemEditorRouter {

    private weak var navigationController: UINavigationController?
    private let todoEditorBuilder: TodoEditorBuilder

    /// Инициализатор.
    /// - Parameters:
    ///  - navigationController: корневой navigation controller приложения.
    init(navigationController: UINavigationController?,
         todoEditorBuilder: TodoEditorBuilder) {
        self.navigationController = navigationController
        self.todoEditorBuilder = todoEditorBuilder
    }

    func navigate(with todoItem: TodoItem?) {
        let todoEditorGraph = todoEditorBuilder.build(initTodoItem: todoItem)
        let todoEditorViewController = todoEditorGraph.viewController

        todoEditorViewController.modalPresentationStyle = .overFullScreen

        navigationController?.topViewController?.present(todoEditorViewController, animated: true, completion: nil)
    }
}
