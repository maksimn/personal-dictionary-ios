//
//  NavToSearchRouterImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

/// Реализация роутера для навигации на экран добавления нового слова в Личный словарь.
final class NavToNewWordRouterImpl: NavToNewWordRouter {

    private weak var navigationController: UINavigationController?
    private let newWordBuilder: NewWordBuilder

    /// Инициализатор.
    /// - Parameters:
    ///  - navigationController: корневой navigation controller приложения.
    ///  - searchBuilder: билдер вложенной фичи "Поиск" по словам в словаре.
    init(navigationController: UINavigationController?,
         newWordBuilder: NewWordBuilder) {
        self.navigationController = navigationController
        self.newWordBuilder = newWordBuilder
    }

    /// Перейти на экран поиска по словам в личном словаре.
    func navigate() {
        let newWordViewController = newWordBuilder.build()

        newWordViewController.modalPresentationStyle = .overFullScreen

        navigationController?.topViewController?.present(newWordViewController, animated: true, completion: nil)
    }
}
