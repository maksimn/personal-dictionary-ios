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
    private let notificationCenter: NotificationCenter
    private let globalSettings: PDGlobalSettings

    private lazy var viewParams: WordListViewParams = {
        WordListViewParams(
            staticContent: WordListViewStaticContent(
                deleteAction: DeleteActionStaticContent(
                    image: UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!
                )
            ),
            styles: WordListViewStyles(
                backgroundColor: globalSettings.appBackgroundColor,
                deleteAction: DeleteActionStyles(
                    backgroundColor: UIColor(red: 1, green: 0.271, blue: 0.227, alpha: 1)
                )
            )
        )
    }()

    init(cudOperations: WordItemCUDOperations,
         translationService: TranslationService,
         notificationCenter: NotificationCenter,
         globalSettings: PDGlobalSettings) {
        self.cudOperations = cudOperations
        self.translationService = translationService
        self.notificationCenter = notificationCenter
        self.globalSettings = globalSettings
    }

    func build() -> WordListMVVM {
        WordListMVVMImpl(cudOperations: cudOperations,
                         translationService: translationService,
                         notificationCenter: notificationCenter,
                         viewParams: viewParams)
    }
}
