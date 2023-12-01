//
//  DictionaryService+DI.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.08.2023.
//

import CoreModule
import SharedFeature
import UIKit

struct DictionaryServiceFactory {

    let secret: String
    let featureName: String
    let bundle: Bundle
    let isErrorSendable: Bool

    func create() -> DictionaryService {
        let ponsDictionaryService = PonsDictionaryService(secret: secret, featureName: featureName)
        let dictionaryServiceLog = DictionaryServiceLog(
            dictionaryService: ponsDictionaryService,
            logger: LoggerImpl(category: featureName)
        )
        let cacheableDictionaryService = CacheableDictionaryService(
            dictionaryService: dictionaryServiceLog,
            featureName: featureName
        )
        let indexedSearchByTranslationDictionaryService = IndexedSearchByTranslationDictionaryService(
            dictionaryService: cacheableDictionaryService,
            featureName: featureName
        )

        if isErrorSendable {
            let errorSendableDictionaryService = ErrorSendableDictionaryService(
                dictionaryService: indexedSearchByTranslationDictionaryService,
                bundle: bundle
            )

            return errorSendableDictionaryService
        } else {
            return indexedSearchByTranslationDictionaryService
        }
    }
}

extension PonsDictionaryService {

    convenience init(secret: String, featureName: String) {
        self.init(
            secret: secret,
            httpClient: LoggableHttpClient(logger: LoggerImpl(category: featureName))
        )
    }
}

extension CacheableDictionaryService {

    init(dictionaryService: DictionaryService, featureName: String) {
        self.init(
            dictionaryService: dictionaryService,
            dictionaryEntryDbInserter: DictionaryEntryDbInserterFactory(featureName: featureName).create(),
            decoder: DictionaryEntryDecoderFactory(featureName: featureName).create(),
            updateWordDbWorker: UpdateWordDbWorkerFactory(featureName: featureName).create()
        )
    }
}

extension ErrorSendableDictionaryService {

    init(dictionaryService: DictionaryService, bundle: Bundle) {
        self.init(
            dictionaryService: dictionaryService,
            sharedMessageSender: SharedMessageStreamImpl.instance,
            messageTemplate: bundle.moduleLocalizedString("LS_LOAD_DICTIONARY_ENTRY_ERROR_TEMPLATE")
        )
    }
}

extension IndexedSearchByTranslationDictionaryService {

    init(dictionaryService: DictionaryService, featureName: String) {
        self.init(
            dictionaryService: dictionaryService,
            createWordTranslationIndexDbWorker: CreateWordTranslationIndexDbWorkerFactory(
                featureName: featureName
            ).create()
        )
    }
}
