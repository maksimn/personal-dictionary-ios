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
        let wordListBuilder = WordListBuilderImpl(shouldAnimateWhenAppear: false, dependency: dependency)
        let searchableWordList = WordListRepositoryImpl(appConfig: dependency.appConfig, bundle: dependency.bundle)
        let noResultFoundText = dependency.bundle.moduleLocalizedString("MLS_NO_WORDS_FOUND")

        weak var viewModelLazy: SearchWordListViewModel?

        let model = SearchWordListModelImpl(
            viewModelBlock: { viewModelLazy },
            searchableWordList: searchableWordList,
            searchTextStream: SearchTextStreamImpl.instance,
            searchModeStream: SearchModeStreamImpl.instance
        )
        let viewModel = SearchWordListViewModelImpl(
            initialData: SearchResultData(searchState: .initial, foundWordList: []),
            model: model
        )
        let view = SearchWordListViewController(
            viewModel: viewModel,
            wordListBuilder: wordListBuilder,
            noResultFoundText: noResultFoundText
        )

        viewModelLazy = viewModel

        return view
    }
}
