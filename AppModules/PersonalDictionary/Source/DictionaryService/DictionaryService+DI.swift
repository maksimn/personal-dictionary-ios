//
//  DictionaryService+DI.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.08.2023.
//

import CoreModule
import SharedFeature
import UIKit

extension DictionaryServiceImpl {

    init(secret: String, category: String, bundle: Bundle, isErrorSendable: Bool = true) {
        let ponsDictionaryService = PonsDictionaryService(secret: secret, category: category)
        let cacheableDictionaryService = CacheableDictionaryService(dictionaryService: ponsDictionaryService)

        if isErrorSendable {
            let errorSendableDictionaryService = ErrorSendableDictionaryService(
                dictionaryService: cacheableDictionaryService,
                bundle: bundle
            )

            self.init(dictionaryService: errorSendableDictionaryService)
        } else {
            self.init(dictionaryService: cacheableDictionaryService)
        }
    }
}

extension PonsDictionaryService {

    convenience init(secret: String, category: String) {
        self.init(
            secret: secret,
            httpClient: LoggableHttpClient(logger: LoggerImpl(category: category))
        )
    }
}

extension CacheableDictionaryService {

    init(dictionaryService: DictionaryService) {
        self.init(
            dictionaryService: dictionaryService,
            dictionaryEntryDbWorker: DictionaryEntryDbWorkerImpl(),
            decoder: PonsDictionaryEntryDecoder(),
            updateWordDbWorker: UpdateWordDbWorkerImpl()
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
