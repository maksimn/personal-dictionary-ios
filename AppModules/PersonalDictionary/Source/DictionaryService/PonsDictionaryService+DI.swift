//
//  PonsDictionaryService+DI.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.08.2023.
//

import CoreModule

extension PonsDictionaryService {

    convenience init(secret: String, category: String) {
        self.init(
            secret: secret,
            httpClient: LoggableHttpClient(logger: LoggerImpl(category: category)),
            decoder: PonsDictionaryEntryDecoder()
        )
    }
}
