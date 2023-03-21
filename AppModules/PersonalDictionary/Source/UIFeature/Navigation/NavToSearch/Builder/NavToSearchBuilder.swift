//
//  NavToSearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

protocol NavToSearchBuilder {

    func build() -> UISearchControllerDelegate
}

/// Реализация билдера фичи "Навигация на экран Поиска".
final class NavToSearchBuilderImpl: NavToSearchBuilder {

    private let dependency: AppDependency

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    func build() -> UISearchControllerDelegate {
        let searchBuilder = SearchBuilder(dependency: dependency)
        let router = NavToSearchRouterImpl(
            navigationController: dependency.navigationController,
            searchBuilder: searchBuilder
        )
        let navToSearch = NavToSearch(
            navigationController: dependency.navigationController,
            navToSearchRouter: router,
            logger: SLoggerImp(category: "PersonalDictionary.NavToSearch")
        )

        return navToSearch
    }
}
