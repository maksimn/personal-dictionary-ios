//
//  WordListDependencies.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.12.2021.
//

import CoreModule
import UIKit

/// Зависимости фичи "Список слов".
final class WordListDependencies {

    /// Параметры представления фичи
    let viewParams: WordListViewParams

    /// ModelStream для событий со словами в личном словаре.
    let wordItemStream: ReadableWordItemStream & RemovedWordItemStream

    /// Служба для выполнения перевода слов на целевой язык
    let translationService: TranslationService

    /// Инициализатор.
    /// - Parameters:
    ///  - configs: конфигурация  списка слов.
    init(configs: WordListConfigs) {
        viewParams = WordListViewParams(
            tableViewParams: WordTableViewParams(
                shouldAnimateWhenAppear: configs.shouldAnimateWhenAppear,
                cellSlideInDuration: 0.5,
                cellSlideInDelayFactor: 0.05,
                deleteActionImage: UIImage(systemName: "trash",
                                           withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!,
                deleteActionBackgroundColor: UIColor(red: 1, green: 0.271, blue: 0.227, alpha: 1)
            ),
            backgroundColor: configs.appConfigs.appViewConfigs.backgroundColor,
            itemHeight: WordItemCell.height,
            cellClass: WordItemCell.self,
            cellReuseIdentifier: "\(WordItemCell.self)",
            cellCornerRadius: 16
        )

        self.wordItemStream = WordItemStreamImpl.instance

        translationService = PonsTranslationService(
            apiData: PonsApiData(url: "https://api.pons.com/v1/dictionary",
                                 secretHeaderKey: "X-Secret",
                                 secret: configs.appConfigs.ponsApiSecret),
            coreService: UrlSessionCoreService(sessionConfiguration: URLSessionConfiguration.default),
            jsonCoder: JSONCoderImpl(),
            logger: SimpleLogger(isLoggingEnabled: configs.appConfigs.isLoggingEnabled)
        )
    }
}
