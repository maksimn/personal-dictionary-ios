//
//  SearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

/// Билдер Фичи "Поиск по словам в словаре".
final class SearchBuilderImpl: ViewControllerBuilder {

    private let appConfig: AppConfig

    private let bundle: Bundle

    /// Инициализатор.
    /// - Parameters:
    ///  - appConfig: зависимости фичи.
    init(appConfig: AppConfig,
         bundle: Bundle) {
        self.appConfig = appConfig
        self.bundle = bundle
    }

    /// Создать экран Поиска.
    /// - Returns:
    ///  - View controller экрана поиска по словам в словаре.
    func build() -> UIViewController {
        SearchViewController(
            noResultFoundText: bundle.moduleLocalizedString("No words found"),
            searchTextInputBuilder: SearchTextInputBuilderImpl(bundle: bundle),
            searchModePickerBuilder: SearchModePickerBuilderImpl(bundle: bundle),
            wordListBuilder: WordListBuilderImpl(
                shouldAnimateWhenAppear: false,
                appConfig: appConfig,
                bundle: bundle
            ),
            searchEngineBuilder: SearchEngineBuilderImpl(appConfig: appConfig, bundle: bundle)
        )
    }
}
