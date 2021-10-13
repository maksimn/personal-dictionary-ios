//
//  RouterImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

import UIKit

final class RouterImpl: Router {

    private let navigationController: UINavigationController
    private let langRepository: LangRepository
    private let notificationCenter: NotificationCenter
    private let wordListRepository: WordListRepository
    private let translationService: TranslationService

    init(navigationController: UINavigationController,
         langRepository: LangRepository,
         wordListRepository: WordListRepository,
         translationService: TranslationService,
         notificationCenter: NotificationCenter) {
        self.langRepository = langRepository
        self.navigationController = navigationController
        self.notificationCenter = notificationCenter
        self.wordListRepository = wordListRepository
        self.translationService = translationService
    }

    func navigateToNewWord() {
        let newWordMVVM = NewWordMVVMImpl(langRepository: langRepository,
                                          notificationCenter: NotificationCenter.default)
        guard let newWordViewController = newWordMVVM.viewController else { return }

        newWordViewController.modalPresentationStyle = .overFullScreen

        navigationController.topViewController?.present(newWordViewController, animated: true, completion: nil)
    }

    func navigateToSearch() {
        let mvvm = SearchWordMVVMImpl(wordListRepository: wordListRepository,
                                      translationService: translationService,
                                      notificationCenter: notificationCenter)
        guard let searchWordVC = mvvm.viewController else { return }

        navigationController.pushViewController(searchWordVC, animated: true)
    }
}
