//
//  RouterImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

import UIKit

final class MainWordListRouterImpl: MainWordListRouter {

    private let navigationController: UINavigationController
    private let newWordBuilder: NewWordBuilder
    private let searchBuilder: SearchBuilder

    init(navigationController: UINavigationController,
         newWordBuilder: NewWordBuilder,
         searchBuilder: SearchBuilder) {
        self.navigationController = navigationController
        self.newWordBuilder = newWordBuilder
        self.searchBuilder = searchBuilder
    }

    func navigateToNewWord() {
        let newWordMVVM = newWordBuilder.build()
        guard let newWordViewController = newWordMVVM.viewController else { return }

        newWordViewController.modalPresentationStyle = .overFullScreen

        navigationController.topViewController?.present(newWordViewController, animated: true, completion: nil)
    }

    func navigateToSearch() {
        let searchWordVC = searchBuilder.build()

        navigationController.pushViewController(searchWordVC, animated: true)
    }
}
