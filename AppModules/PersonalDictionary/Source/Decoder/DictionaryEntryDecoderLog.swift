//
//  DictionaryEntryDecoder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import CoreModule
import Foundation

struct DictionaryEntryDecoderLog: DictionaryEntryDecoder {

    let decoder: DictionaryEntryDecoder
    let logger: Logger

    func decode(_ data: Data) throws -> DictionaryEntry {
        do {
            logger.log("Decoding dictionary entry data...\nData = \(data)", level: .info)

            let result = try decoder.decode(data)

            logger.log("Decoded dictionary entry result = \(result)", level: .info)

            return result
        } catch {
            logger.log("Dictionary entry decoding error = \(error)", level: .error)

            throw error
        }
    }
}
