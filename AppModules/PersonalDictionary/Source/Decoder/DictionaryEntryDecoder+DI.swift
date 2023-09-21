//
//  DictionaryEntryDecoder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import CoreModule

struct DictionaryEntryDecoderFactory {

    let featureName: String

    func create() -> DictionaryEntryDecoder {
        let ponsDictionaryEntryDecoder = PonsDictionaryEntryDecoder()
        let dictionaryEntryDecoderLog = DictionaryEntryDecoderLog(
            decoder: ponsDictionaryEntryDecoder,
            logger: LoggerImpl(category: featureName)
        )

        return dictionaryEntryDecoderLog
    }
}
