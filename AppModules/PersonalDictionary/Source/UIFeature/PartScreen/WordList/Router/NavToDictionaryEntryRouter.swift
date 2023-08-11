//
//  NavToDictionaryEntryRouter.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.08.2023.
//

import CoreModule
import UIKit

struct NavToDictionaryEntryRouter<Builder: ParametrizedViewControllerBuilder>: ParametrizedRouter
    where Builder.Parameter == Word.Id {

    private weak var navigationController: UINavigationController?
    private let builder: Builder

    init(navigationController: UINavigationController?, builder: Builder) {
        self.navigationController = navigationController
        self.builder = builder
    }

    func navigate(_ id: Word.Id) {
        let viewController = builder.build(id)

        navigationController?.pushViewController(viewController, animated: true)
    }
}
