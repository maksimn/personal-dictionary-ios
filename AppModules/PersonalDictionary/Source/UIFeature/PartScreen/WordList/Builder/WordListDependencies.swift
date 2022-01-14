//
//  WordListDependencies.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.12.2021.
//

import CoreModule
import UIKit

final class WordListDependencies {

    let viewParams: WordListViewParams

    let wordItemStream: ReadableWordItemStream & RemovedWordItemStream

    let translationService: TranslationService

    let logger: Logger

    init(appConfigs: AppConfigs) {
        viewParams = WordListViewParams(
            staticContent: WordListViewStaticContent(
                tableViewParams: WordTableViewParams(
                    cellSlideInDuration: 0.5,
                    cellSlideInDelayFactor: 0.05,
                    deleteActionImage: UIImage(systemName: "trash",
                                               withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!,
                    deleteActionBackgroundColor: UIColor(red: 1, green: 0.271, blue: 0.227, alpha: 1)
                )
            ),
            styles: WordListViewStyles(
                backgroundColor: appConfigs.appViewConfigs.backgroundColor,
                itemHeight: WordItemCell.height,
                cellClass: WordItemCell.self,
                cellReuseIdentifier: "\(WordItemCell.self)",
                cellCornerRadius: 16
            )
        )

        self.wordItemStream = WordItemStreamImpl.instance

        self.logger = SimpleLogger(isLoggingEnabled: appConfigs.isLoggingEnabled)

        translationService = PonsTranslationService(
            apiData: PonsApiData(url: "https://api.pons.com/v1/dictionary",
                                 secretHeaderKey: "X-Secret",
                                 secret: appConfigs.ponsApiSecret),
            coreService: UrlSessionCoreService(sessionConfiguration: URLSessionConfiguration.default),
            jsonCoder: JSONCoderImpl(),
            logger: logger
        )
    }
}
