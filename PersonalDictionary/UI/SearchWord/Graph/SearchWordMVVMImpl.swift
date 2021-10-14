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
        baseContent: staticContent,
        searchBarPlaceholderText: NSLocalizedString("Enter a word for searching", comment: ""),
        noWordsFoundText: NSLocalizedString("No words found", comment: ""),
        searchByLabelText: NSLocalizedString("Search by:", comment: ""),
        sourceWordText: NSLocalizedString("source word", comment: ""),
        translationText: NSLocalizedString("translation", comment: "")
    )

    init(wordListRepository: WordListRepository,
         translationService: TranslationService,
         notificationCenter: NotificationCenter) {
        super.init()
        viewOne = SearchWordViewController(staticContent: searchStaticContent, styles: styles)
        guard let viewOne = viewOne else { return }
        let model = SearchWordModelImpl(wordListRepository: wordListRepository,
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
