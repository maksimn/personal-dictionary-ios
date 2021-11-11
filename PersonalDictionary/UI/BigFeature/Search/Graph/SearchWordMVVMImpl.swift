//
//  SearchWordMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

import UIKit

final class SearchWordMVVMImpl: WordListMVVMImpl {

    private var viewOne: SearchWordViewController?

    lazy var searchStaticContent = SearchWordViewStaticContent(
        baseContent: WordListViewStaticContent(
            deleteAction: DeleteActionStaticContent(
                image: UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!
            )
        ),
        searchBarPlaceholderText: NSLocalizedString("Enter a word for searching", comment: ""),
        noWordsFoundText: NSLocalizedString("No words found", comment: ""),
        searchByLabelText: NSLocalizedString("Search by:", comment: ""),
        sourceWordText: NSLocalizedString("source word", comment: ""),
        translationText: NSLocalizedString("translation", comment: "")
    )

    init(globalViewSettings: GlobalViewSettings,
         wordListRepository: WordListRepository,
         translationService: TranslationService,
         notificationCenter: NotificationCenter) {
        super.init()
        viewOne = SearchWordViewController(params: SearchWordViewParams(
                                            staticContent: searchStaticContent,
                                            styles: WordListViewStyles(
                                                backgroundColor: globalViewSettings.appBackgroundColor,
                                                deleteAction: DeleteActionStyles(
                                                   backgroundColor: UIColor(red: 1, green: 0.271, blue: 0.227, alpha: 1)
                                                )
                                            )))
        guard let viewOne = viewOne else { return }
        let model = SearchWordModelImpl(cudOperations: wordListRepository,
                                        translationService: translationService,
                                        notificationCenter: notificationCenter)
        let viewModel = SearchWordViewModelImpl(model: model, view: viewOne)

        viewOne.viewModel = viewModel
        model.viewModel = viewModel
    }

    override var viewController: UIViewController? {
        viewOne
    }
}
