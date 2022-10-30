//
//  SearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

/// Билдер Фичи "Поиск по словам в словаре".
final class SearchBuilderImpl: ViewControllerBuilder {

    private weak var dependency: RootDependency?

    init(dependency: RootDependency?) {
        self.dependency = dependency
    }

    /// Создать экран Поиска.
    /// - Returns:
    ///  - View controller экрана поиска по словам в словаре.
    func build() -> UIViewController {
        guard let dependency = dependency else { return UIViewController() }

        return SearchViewController(
            noResultFoundText: dependency.bundle.moduleLocalizedString("No words found"),
            searchTextInputBuilder: SearchTextInputBuilderImpl(bundle: dependency.bundle),
            searchModePickerBuilder: SearchModePickerBuilderImpl(bundle: dependency.bundle),
            wordListBuilder: WordListBuilderImpl(shouldAnimateWhenAppear: false, dependency: dependency),
            searchEngine: SearchEngineImpl(
                searchableWordList: CoreWordListRepository(appConfig: dependency.appConfig, bundle: dependency.bundle)
            )
        )
    }
}
