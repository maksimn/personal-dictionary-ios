//
//  App.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 22.02.2023.
//

import UIKit

protocol RootDependency {

    var appConfig: AppConfig { get }

    var bundle: Bundle { get }
}

protocol AppDependency: RootDependency {

    var navigationController: UINavigationController { get }
}

struct AppDependencyImpl: AppDependency {

    let navigationController: UINavigationController

    let appConfig: AppConfig

    let bundle: Bundle
}
