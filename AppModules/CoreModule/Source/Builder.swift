//
//  Builder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 27.10.2022.
//

import UIKit

public protocol ViewBuilder {

    func build() -> UIView
}

public protocol ViewControllerBuilder {

    func build() -> UIViewController
}

public protocol SearchControllerBuilder {

    func build() -> UISearchController
}
