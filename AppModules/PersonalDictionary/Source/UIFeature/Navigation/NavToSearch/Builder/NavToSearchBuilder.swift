//
//  NavToSearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

/// Ширина представления фичи "Навигация на экран Поиска".
enum NavToSearchWidth {
    case full /// полная (во всю ширину экрана).
    case smaller /// меньшая ширина, чем full.
}

/// Реализация билдера фичи "Навигация на экран Поиска".
final class NavToSearchBuilderImpl: ViewBuilder {

    private let width: NavToSearchWidth

    private weak var dependency: AppDependency?

    init(width: NavToSearchWidth,
         dependency: AppDependency) {
        self.width = width
        self.dependency = dependency
    }

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView {
        guard let dependency = dependency else { return UIView() }
        let searchBuilder = SearchBuilder(dependency: dependency)
        let router = NavToSearchRouterImpl(
            navigationController: dependency.navigationController,
            searchBuilder: searchBuilder
        )
        let view = NavToSearchView(width: width, router: router)

        return view
    }
}
