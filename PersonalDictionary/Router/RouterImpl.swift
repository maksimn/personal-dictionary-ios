//
//  RouterImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

import UIKit

final class RouterImpl: Router {

    private let navigationController: UINavigationController
    private let builder: WordListBuilder

    init(navigationController: UINavigationController,
         builder: WordListBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }

    func navigateToNewWord() {
        let newWordMVVM = builder.buildNewWordMVVM()
        guard let newWordViewController = newWordMVVM.viewController else { return }

        newWordViewController.modalPresentationStyle = .overFullScreen

        navigationController.topViewController?.present(newWordViewController, animated: true, completion: nil)
    }

    func navigateToSearch() {
        let mvvm = builder.buildSearchWordMVVM()
        guard let searchWordVC = mvvm.viewController else { return }

        navigationController.pushViewController(searchWordVC, animated: true)
    }
}
