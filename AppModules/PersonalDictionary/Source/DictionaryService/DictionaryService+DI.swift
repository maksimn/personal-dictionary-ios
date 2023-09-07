//
//  DictionaryService+DI.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.08.2023.
//

import CoreModule
import SharedFeature
import UIKit

extension PonsDictionaryService {

    convenience init(secret: String, category: String) {
        self.init(
            secret: secret,
            httpClient: LoggableHttpClient(logger: LoggerImpl(category: category)),
            decoder: PonsDictionaryEntryDecoder()
        )
    }
}

extension MessagableDictionaryService {

    init(secret: String, category: String, bundle: Bundle) {
        self.init(
            dictionaryService: PonsDictionaryService(secret: secret, category: category),
            sharedMessageSender: SharedMessageStreamImpl.instance,
            messageTemplate: bundle.moduleLocalizedString("LS_LOAD_DICTIONARY_ENTRY_ERROR_TEMPLATE")
        )
    }
}
