//
//  NavToSearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

final class NavToSearchBuilder: ViewBuilder {

    private let dependency: AppDependency

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView {
        let searchBuilder = SearchBuilder(dependency: dependency)
        let router = NavToSearchRouter(
            navigationController: dependency.navigationController,
            searchBuilder: searchBuilder,
            mainScreenStateStream: MainScreenStateStreamImpl.instance
        )
        let view = NavToSearchView(router: router)

        return view
    }
}
