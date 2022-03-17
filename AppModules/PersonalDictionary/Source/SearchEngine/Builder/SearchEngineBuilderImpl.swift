//
//  SearchEngineBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

/// Реализация билдера Фичи "Поисковый движок".
final class SearchEngineBuilderImpl: SearchEngineBuilder {

    private let appConfig: Config

    /// Инициализатор.
    /// - Parameters:
    ///  - appConfig: конфигурация приложения.
    init(appConfig: Config) {
        self.appConfig = appConfig
    }

    /// Создать объект поискового движка.
    /// - Returns: объект поискового движка.
    func build() -> SearchEngine {
        SearchEngineImpl(searchableWordList: WordListRepositoryGraphImpl(appConfig: appConfig).repository)
    }
}
