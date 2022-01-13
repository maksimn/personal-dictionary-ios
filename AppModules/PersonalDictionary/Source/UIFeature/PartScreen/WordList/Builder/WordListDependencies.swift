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
                deleteAction: DeleteActionStaticContent(
                    image: UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!
                )
            ),
            styles: WordListViewStyles(
                backgroundColor: appConfigs.appViewConfigs.appBackgroundColor,
                deleteAction: DeleteActionStyles(
                    backgroundColor: UIColor(red: 1, green: 0.271, blue: 0.227, alpha: 1)
                ),
                itemHeight: WordItemCell.height,
                cellClass: WordItemCell.self,
                cellReuseIdentifier: "\(WordItemCell.self)",
                cellCornerRadius: 16
            )
        )

        self.wordItemStream = WordItemStreamImpl.instance

        self.logger = SimpleLogger(isLoggingEnabled: appConfigs.appParams.coreModuleParams.isLoggingEnabled)

        // Building translationService:
        let ponsApiData = PonsApiData(url: "https://api.pons.com/v1/dictionary",
                                      secretHeaderKey: "X-Secret",
                                      secret: appConfigs.ponsApiSecret)
        let urlSessionCoreService = UrlSessionCoreService(
            sessionConfiguration: appConfigs.appParams.coreModuleParams.urlSessionConfiguration
        )

        translationService = PonsTranslationService(
            apiData: ponsApiData,
            coreService: urlSessionCoreService,
            jsonCoder: JSONCoderImpl(),
            logger: logger
        )
    }
}
