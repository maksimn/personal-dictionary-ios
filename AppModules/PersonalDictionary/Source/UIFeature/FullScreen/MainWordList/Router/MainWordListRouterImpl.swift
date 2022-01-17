//
//  RouterImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

import UIKit

/// Реализация роутера для навигации от Главного списка слов к другим экранам приложения.
final class MainWordListRouterImpl: MainWordListRouter {

    private let navigationController: UINavigationController
    private let newWordBuilder: NewWordBuilder
    private let searchBuilder: SearchBuilder

    /// Инициализатор.
    /// - Parameters:
    ///  - navigationController: корневой navigation controller приложения.
    ///  - newWordBuilder: билдер фичи "Добавление нового слова" в словарь.
    ///  - searchBuilder: билдер вложенной фичи "Поиск" по словам в словаре.
    init(navigationController: UINavigationController,
         newWordBuilder: NewWordBuilder,
         searchBuilder: SearchBuilder) {
        self.navigationController = navigationController
        self.newWordBuilder = newWordBuilder
        self.searchBuilder = searchBuilder
    }

    /// Перейти на экран добавления нового слова.
    func navigateToNewWord() {
        let newWordMVVM = newWordBuilder.build()
        guard let newWordViewController = newWordMVVM.viewController else { return }

        newWordViewController.modalPresentationStyle = .overFullScreen

        navigationController.topViewController?.present(newWordViewController, animated: true, completion: nil)
    }

    /// Перейти на экран поиска по словам в личном словаре.
    func navigateToSearch() {
        let searchWordVC = searchBuilder.build()

        navigationController.pushViewController(searchWordVC, animated: true)
    }
}
