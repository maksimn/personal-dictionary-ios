//
//  WordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

/// Реализация билдера фичи "Поиск по списку слов".
final class SearchWordListBuilderImpl: SearchWordListBuilder {

    private weak var dependency: RootDependency?

    init(dependency: RootDependency) {
        self.dependency = dependency
    }

    func build() -> SearchWordListGraph {
        guard let dependency = dependency else {
            struct Empty: SearchWordListGraph {
                let viewController = UIViewController()
                var model: SearchWordListModel?
            }
            return Empty()
        }

        return SearchWordListGraphImpl(
            wordListBuilder: WordListBuilderImpl(shouldAnimateWhenAppear: false, dependency: dependency),
            searchableWordList: WordListRepositoryImpl(appConfig: dependency.appConfig, bundle: dependency.bundle),
            noResultFoundText: dependency.bundle.moduleLocalizedString("No words found")
        )
    }
}
