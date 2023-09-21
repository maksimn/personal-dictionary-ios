//
//  LangRepository.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import CoreModule
import Foundation

struct LangRepositoryFactory {

    let langData: LangData
    let featureName: String

    func create() -> LangRepository {
        let udLangRepository = UDLangRepository(userDefaults: UserDefaults.standard, data: langData)
        let langRepositoryLog = LangRepositoryLog(
            langRepository: udLangRepository,
            logger: LoggerImpl(category: featureName)
        )

        return langRepositoryLog
    }
}
