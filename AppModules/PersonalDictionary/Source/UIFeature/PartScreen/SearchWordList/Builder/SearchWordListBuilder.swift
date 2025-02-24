//
//  SearchWordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2022.
//

import CoreModule
import UIKit

/// Реализация билдера фичи "Поиск по списку слов".
final class SearchWordListBuilder: ViewControllerBuilder {

    private let dependency: AppDependency

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    func build() -> UIViewController {
        let featureName = "PersonalDictionary.SearchWordList"

        let model = SearchWordListModelImpl(
            searchableWordList: SearchableWordListFactory(featureName: featureName).create(),
            translationSearchableWordList: TranslationSearchableWordListFactory(featureName: featureName).create()
        )
        let viewModel = SearchWordListViewModelImpl(
            initialData: initialData(),
            model: model,
            searchTextStream: SearchTextStreamFactory(featureName: featureName).create(),
            searchModeStream: SearchModeStreamFactory(featureName: featureName).create()
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
}
