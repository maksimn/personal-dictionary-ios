//
//  NavToNewWordBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

/// Implementation of the "Navigation to New Word Screen" feature builder.
final class NavToNewWordBuilder: ViewBuilder {

    private let dependency: AppDependency

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    /// Create the feature.
    /// - Returns: feature view.
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
