//
//  NavToNewWordBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

/// Реализация билдера фичи "Навигация на экран добавления нового слова".
final class NavToNewWordBuilder: ViewBuilder {

    private let dependency: AppDependency

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView {
        let newWordBuilder = NewWordBuilder(
            bundle: dependency.bundle,
            langData: dependency.appConfig.langData
        )
        let router = NavToNewWordRouter(
            navigationController: dependency.navigationController,
            newWordBuilder: newWordBuilder
        )
        let view = NavToNewWordView(
            navToNewWordImage: UIImage(named: "icon-plus", in: dependency.bundle, compatibleWith: nil)!,
            router: router
        )

        return view
    }
}
