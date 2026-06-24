//
//  MainNavigatorImpl.swift
//  SuperList
//
//  Created by Maksim Ivanov on 26.02.2022.
//

import UIKit

/// Container of navigation elements on the main screen of the application.
protocol MainNavigator {

    /// Add navigation element views.
    func appendTo(rootView: UIView)

    func viewWillLayoutSubviews()

    func searchTextInputWillDismiss()

    func searchTextInputDidDismiss()

    func searchTextInputWillPresent()

    func searchTextInputDidPresent()
}
