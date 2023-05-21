//
//  Builder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 27.10.2022.
//

import SwiftUI
import UIKit

public protocol ViewBuilder {

    func build() -> UIView
}

public protocol ParametrizedViewBuilder {

    associatedtype Parameter

    func build(_ parameter: Parameter) -> UIView
}

public protocol ViewControllerBuilder {

    func build() -> UIViewController
}

public protocol ParametrizedViewControllerBuilder {

    associatedtype Parameter

    func build(_ parameter: Parameter) -> UIViewController
}

public protocol SearchControllerBuilder {

    func build() -> UISearchController
}

public protocol SwiftViewBuilder {
    associatedtype ViewType: View

    func build() -> ViewType
}
