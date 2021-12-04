//
//  WordListDependencies.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.12.2021.
//

import UIKit

final class WordListDependencies {

    let cudOperations: WordItemCUDOperations
    let translationService: TranslationService
    let wordItemStream: ReadableWordItemStream & RemovedWordItemStream = WordItemStreamImpl.instance
    let logger: Logger

    private(set) lazy var viewParams = WordListViewParams(
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

    private let appViewConfigs: AppViewConfigs

    init(cudOperations: WordItemCUDOperations,
         translationService: TranslationService,
         appViewConfigs: AppViewConfigs,
         logger: Logger) {
        self.cudOperations = cudOperations
        self.translationService = translationService
        self.appViewConfigs = appViewConfigs
        self.logger = logger
    }
}
