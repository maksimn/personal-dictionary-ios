//
//  MainNavigatorBuilderImpl.swift
//  SuperList
//
//  Created by Maksim Ivanov on 26.02.2022.
//

import CoreModule
import UIKit

protocol MainNavigatorDependency: BaseDependency {

    var langRepository: LangRepository { get }
}

final class MainNavigatorBuilderImpl: MainNavigatorBuilder {

    let navigationController: UINavigationController

    let appConfig: Config

    let logger: Logger

    let wordListRepository: WordListRepository

    let langRepository: LangRepository

    init(dependency: MainNavigatorDependency) {
        self.navigationController = dependency.navigationController
        self.appConfig = dependency.appConfig
        self.logger = dependency.logger
        self.wordListRepository = dependency.wordListRepository
        self.langRepository = dependency.langRepository
    }

    func build() -> MainNavigator {
        MainNavigatorImpl(
            navigationController: navigationController,
            navToSearchBuilder: NavToSearchBuilderImpl(width: .full, dependency: self),
            navToFavoriteWordListBuilder: NavToFavoriteWordListBuilderImpl(dependency: self),
            navToNewWordBuilder: NavToNewWordBuilderImpl(dependency: self),
            navToOtherAppBuilder: NavToOtherAppBuilderImpl(appParams: appConfig.appParams)
        )
    }
}

extension MainNavigatorBuilderImpl: NavToSearchDependency,
                                    NavToFavoriteWordListDependency,
                                    NavToNewWordDependency { }
