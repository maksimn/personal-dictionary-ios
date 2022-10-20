//
//  SearchEngineBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

/// Реализация билдера Фичи "Поисковый движок".
final class SearchEngineBuilderImpl: SearchEngineBuilder {

    private let appConfig: AppConfig
    private let bundle: Bundle

    /// Инициализатор.
    /// - Parameters:
    ///  - appConfig: конфигурация приложения.
    init(appConfig: AppConfig,
         bundle: Bundle) {
        self.appConfig = appConfig
        self.bundle = bundle
    }

    /// Создать объект поискового движка.
    /// - Returns: объект поискового движка.
    func build() -> SearchEngine {
        SearchEngineImpl(searchableWordList: CoreWordListRepository(appConfig: appConfig, bundle: bundle))
    }
}
