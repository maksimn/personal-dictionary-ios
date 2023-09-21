//
//  LangRepositoryLog.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2023.
//

import CoreModule

struct LangRepositoryLog: LangRepository {

    var langRepository: LangRepository
    let logger: Logger

    var allLangs: [Lang] {
        let result = langRepository.allLangs

        logger.log("All supported dictionary languages fetched: \(result)", level: .info)

        return result
    }

    var sourceLang: Lang {
        get {
            let result = langRepository.sourceLang

            logger.log("Source language fetched from the Lang Repository: \(result)", level: .info)

            return result
        }
        set {
            langRepository.sourceLang = newValue

            logger.log("Source language saved in the Lang Repository: \(newValue)", level: .info)
        }
    }

    var targetLang: Lang {
        get {
            let result = langRepository.targetLang

            logger.log("Target language fetched from the Lang Repository: \(result)", level: .info)

            return result
        }
        set {
            langRepository.targetLang = newValue

            logger.log("Target language saved in the Lang Repository: \(newValue)", level: .info)
        }
    }
}
