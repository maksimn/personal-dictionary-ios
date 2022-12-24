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
        let searchTextInputBuilder = SearchTextInputBuilderImpl(bundle: dependency.bundle)
        let searchModePickerBuilder = SearchModePickerBuilderImpl(bundle: dependency.bundle)
        let searchWordListBuilder = SearchWordListBuilderImpl(dependency: dependency)

        let searchTextInputGraph = searchTextInputBuilder.build()
        let searchModePickerGraph = searchModePickerBuilder.build()
        let searchWordListGraph = searchWordListBuilder.build()

        _ = searchTextInputGraph.viewModel?.searchText.subscribe(onNext: { searchText in
            guard let searchMode = searchModePickerGraph.viewModel?.searchMode.value else { return }

            searchWordListGraph.model?.performSearch(for: searchText, mode: searchMode)
        })
        _ = searchModePickerGraph.viewModel?.searchMode.subscribe(onNext: { searchMode in
            guard let searchText = searchTextInputGraph.viewModel?.searchText.value else { return }

            searchWordListGraph.model?.performSearch(for: searchText, mode: searchMode)
        })

        return SearchViewController(
            searchTextInputView: searchTextInputGraph.uiview,
            searchModePickerView: searchModePickerGraph.uiview,
            searchWordListViewController: searchWordListGraph.viewController
        )
    }
}
