//
//  SearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

/// Билдер Фичи "Поиск по словам в словаре".
final class SearchBuilder: ViewControllerBuilder {

    private weak var dependency: RootDependency?

    init(dependency: RootDependency?) {
        self.dependency = dependency
    }

    /// Создать экран Поиска.
    /// - Returns:
    ///  - View controller экрана поиска по словам в словаре.
    func build() -> UIViewController {
        guard let dependency = dependency else { return UIViewController() }
        let searchInputBuilder = SearchInputBuilderImpl(bundle: dependency.bundle)
        let searchWordListBuilder = SearchWordListBuilderImpl(dependency: dependency)

        let searchInputGraph = searchInputBuilder.build()
        let searchWordListGraph = searchWordListBuilder.build()

        return SearchViewController(
            searchTextInputView: searchInputGraph.navBarView,
            searchModePickerView: searchInputGraph.view,
            searchWordListViewController: searchWordListGraph.viewController
        )
    }
}
