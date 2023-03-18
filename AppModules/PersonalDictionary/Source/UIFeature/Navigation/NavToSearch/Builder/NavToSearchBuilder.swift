//
//  NavToSearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

/// Реализация билдера фичи "Навигация на экран Поиска".
final class NavToSearchBuilder: NSObject, SearchControllerBuilder, UISearchResultsUpdating {

    private let dependency: AppDependency

    private lazy var router = NavToSearchRouter(
        navigationController: dependency.navigationController,
        searchBuilder: SearchBuilder(dependency: dependency)
    )

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    func build() -> UISearchController {
        let searchController = UISearchController(searchResultsController: nil)

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = ""

        return searchController
    }

    func updateSearchResults(for searchController: UISearchController) {
        router.navigate()
    }
}
