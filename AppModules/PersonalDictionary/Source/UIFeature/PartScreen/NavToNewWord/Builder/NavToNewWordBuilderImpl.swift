//
//  NavToNewWordBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

/// Реализация билдера фичи "Навигация на экран добавления нового слова".
final class NavToNewWordBuilderImpl: NavToNewWordBuilder {

    private weak var dependency: AppDependency?

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView {
        guard let dependency = dependency else { return UIView() }
        let langRepository = LangRepositoryImpl(
            userDefaults: UserDefaults.standard,
            data: dependency.appConfig.langData
        )
        let newWordBuilder = NewWordBuilderImpl(
            bundle: dependency.bundle,
            langRepository: langRepository
        )
        let router = NavToNewWordRouterImpl(
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
