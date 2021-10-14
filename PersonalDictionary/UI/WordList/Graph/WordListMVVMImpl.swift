//
//  WordListMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

class WordListMVVMImpl: WordListMVVM {

    private var view: WordListViewController?

    let staticContent = WordListViewStaticContent(
        newWordButtonImage: UIImage(named: "icon-plus")!,
        deleteAction: DeleteActionStaticContent(
            image: UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!
        )
    )

    let styles = WordListViewStyles(
        backgroundColor: appBackgroundColor,
        deleteAction: DeleteActionStyles(
            backgroundColor: UIColor(red: 1, green: 0.271, blue: 0.227, alpha: 1)
        )
    )

    init() {
        view = nil
    }

    init(navigationController: UINavigationController,
         langRepository: LangRepository,
         wordListRepository: WordListRepository,
         translationService: TranslationService,
         notificationCenter: NotificationCenter) {
        view = WordListViewController(staticContent: staticContent, styles: styles)
        guard let view = view else { return }
        let router = RouterImpl(navigationController: navigationController,
                                langRepository: langRepository,
                                wordListRepository: wordListRepository,
                                translationService: translationService,
                                notificationCenter: notificationCenter)
        let model = WordListModelImpl(wordListRepository: wordListRepository,
                                      translationService: translationService,
                                      notificationCenter: notificationCenter)
        let viewModel = WordListViewModelImpl(model: model, view: view, router: router)

        view.viewModel = viewModel
        model.viewModel = viewModel
    }

    var viewController: UIViewController? {
        view
    }

    var navigationController: UINavigationController? {
        view?.navigationController
    }
}
