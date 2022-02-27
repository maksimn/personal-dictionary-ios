//
//  WordListRepositoryGraphImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 27.02.2022.
//

import CoreModule

/// DI контейнер хранилища списка слов.
final class WordListRepositoryGraphImpl: WordListRepositoryGraph {

    /// Хранилище списка слов.
    let repository: WordListRepository

    /// Инициализатор.
    /// - Parameters:
    ///  - appConfig: конфигурация приложения.
    init(appConfig: Config) {
        let bundle = Bundle(for: type(of: self))
        let langRepository = LangRepositoryImpl(userDefaults: UserDefaults.standard,
                                                data: appConfig.langData)
        let logger = LoggerImpl(isLoggingEnabled: appConfig.isLoggingEnabled)

        repository = CoreWordListRepository(
            args: CoreWordListRepositoryArgs(bundle: bundle,
                                             persistentContainerName: "StorageModel"),
            langRepository: langRepository,
            logger: logger
        )
    }
}

