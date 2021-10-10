//
//  WordListMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

final class WordListMVVMImpl: WordListMVVM {

    private let view: WordListViewController

    init(langRepository: LangRepository,
         wordListRepository: WordListRepository,
         translationService: TranslationService,
         notificationCenter: NotificationCenter) {
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

        view = WordListViewController(staticContent: staticContent, styles: styles)
        let router = RouterImpl(viewController: view, langRepository: langRepository)
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
}
