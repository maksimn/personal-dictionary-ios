//
//  SearchWordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2022.
//

/// Реализация билдера фичи "Поиск по списку слов".
final class SearchWordListBuilder: ViewControllerBuilder {

    private let dependency: RootDependency

    init(dependency: RootDependency) {
        self.dependency = dependency
    }

    func build() -> UIViewController {
        let model = SearchWordListModelImpl(searchableWordList: searchableWordList())
        let viewModel = SearchWordListViewModelImpl(
            initialData: initialData(),
            model: model,
            searchTextStream: SearchTextStreamImpl.instance,
            searchModeStream: SearchModeStreamImpl.instance
        )
        let view = SearchWordListViewController(
            viewModel: viewModel,
            wordListBuilder: wordListBuilder(),
            labelText: labelText(),
            theme: Theme.data
        )

        return view
    }

    private func initialData() -> SearchResultData {
        SearchResultData(
            searchState: .initial,
            foundWordList: []
        )
    }

    private func wordListBuilder() -> WordListBuilder {
        WordListBuilderImpl(
            shouldAnimateWhenAppear: false,
            dependency: dependency
        )
    }

    private func labelText() -> String {
        dependency.bundle.moduleLocalizedString("LS_NO_WORDS_FOUND")
    }

    private func searchableWordList() -> SearchableWordList {
        WordListRepositoryImpl(
            appConfig: dependency.appConfig,
            bundle: dependency.bundle
        )
    }
}
