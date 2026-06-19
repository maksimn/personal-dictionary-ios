//
//  NavToSearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

protocol NavToSearchBuilder {

    func build() -> NavToSearchRouter
}

/// Implementation of the "Navigation to Search Screen" feature builder.
final class NavToSearchBuilderImpl: NavToSearchBuilder {

    private let dependency: AppDependency

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    func build() -> NavToSearchRouter {
        let searchBuilder = SearchBuilder(dependency: dependency)
        let router = NavToSearchRouterImpl(
            navigationController: dependency.navigationController,
            searchBuilder: searchBuilder
        )

        return router
    }
}
