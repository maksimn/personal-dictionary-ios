//
//  WordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

final class WordListBuilderImpl: WordListBuilder {

    private let cudOperations: WordItemCUDOperations
    private let translationService: TranslationService
    private let wordItemStream: WordItemStream
    private let appViewConfigs: AppViewConfigs
    private let logger: Logger

    private lazy var viewParams: WordListViewParams = {
        WordListViewParams(
            staticContent: WordListViewStaticContent(
                deleteAction: DeleteActionStaticContent(
                    image: UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!
                )
            ),
            styles: WordListViewStyles(
                backgroundColor: appViewConfigs.appBackgroundColor,
                deleteAction: DeleteActionStyles(
                    backgroundColor: UIColor(red: 1, green: 0.271, blue: 0.227, alpha: 1)
                ),
                itemHeight: WordItemCell.height,
                cellClass: WordItemCell.self,
                cellReuseIdentifier: "\(WordItemCell.self)",
                cellCornerRadius: 16
            )
        )
    }()

    init(cudOperations: WordItemCUDOperations,
         translationService: TranslationService,
         wordItemStream: WordItemStream,
         appViewConfigs: AppViewConfigs,
         logger: Logger) {
        self.cudOperations = cudOperations
        self.translationService = translationService
        self.wordItemStream = wordItemStream
        self.appViewConfigs = appViewConfigs
        self.logger = logger
    }

    func build() -> WordListMVVM {
        WordListMVVMImpl(cudOperations: cudOperations,
                         translationService: translationService,
                         wordItemStream: wordItemStream,
                         viewParams: viewParams,
                         logger: logger)
    }
}
