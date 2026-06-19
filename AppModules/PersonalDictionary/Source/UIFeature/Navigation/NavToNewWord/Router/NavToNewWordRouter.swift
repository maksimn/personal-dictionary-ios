//
//  NavToSearchRouterImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

/// Implementation of the router for navigation to the new word addition screen in the Personal Dictionary.
final class NavToNewWordRouter: Router {

    private weak var navigationController: UINavigationController?
    private let newWordBuilder: ViewControllerBuilder

    /// Initializer.
    /// - Parameters:
    ///  - navigationController: root navigation controller of the application.
    ///  - searchBuilder: builder of the nested "Search" feature for dictionary words.
    init(navigationController: UINavigationController?,
         newWordBuilder: ViewControllerBuilder) {
        self.navigationController = navigationController
        self.newWordBuilder = newWordBuilder
    }

    /// Navigate to the search screen for words in the personal dictionary.
    func navigate() {
        let newWordViewController = newWordBuilder.build()

        newWordViewController.modalPresentationStyle = .overFullScreen

        navigationController?.topViewController?.present(newWordViewController, animated: true, completion: nil)
    }
}
