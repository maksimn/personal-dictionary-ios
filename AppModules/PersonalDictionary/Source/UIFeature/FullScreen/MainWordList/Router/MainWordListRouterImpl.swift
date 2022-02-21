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

    /// Инициализатор.
    /// - Parameters:
    ///  - navigationController: корневой navigation controller приложения.
    ///  - newWordBuilder: билдер фичи "Добавление нового слова" в словарь.
    init(navigationController: UINavigationController,
         newWordBuilder: NewWordBuilder) {
        self.navigationController = navigationController
        self.newWordBuilder = newWordBuilder
    }

    /// Перейти на экран добавления нового слова.
    func navigateToNewWord() {
        let newWordMVVM = newWordBuilder.build()
        guard let newWordViewController = newWordMVVM.viewController else { return }

        newWordViewController.modalPresentationStyle = .overFullScreen

        navigationController.topViewController?.present(newWordViewController, animated: true, completion: nil)
    }
}
