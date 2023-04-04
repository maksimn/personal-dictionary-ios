//
//  SearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import UIKit

/// Билдер Фичи "Поиск по словам в словаре".
final class SearchBuilder: ViewControllerBuilder {

    private let dependency: RootDependency

    init(dependency: RootDependency) {
        self.dependency = dependency
    }

    /// Создать экран Поиска.
    /// - Returns:
    ///  - View controller экрана поиска по словам в словаре.
    func build() -> UIViewController {
        SearchViewController(
            searchModePickerBuilder: SearchModePickerBuilder(bundle: dependency.bundle),
            searchWordListBuilder: SearchWordListBuilder(dependency: dependency),
            theme: Theme.data
        )
    }
}
