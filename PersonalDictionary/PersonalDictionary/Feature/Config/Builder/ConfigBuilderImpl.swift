//
//  ConfigBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import CoreModule

final class ConfigBuilderImpl: ConfigBuilder {

    private let appConfigs = ConfigDependencies().appConfigs
    private let coreRouter: CoreRouter?
    private let routingButtonTitle: String

    init(coreRouter: CoreRouter?,
         routingButtonTitle: String) {
        self.coreRouter = coreRouter
        self.routingButtonTitle = routingButtonTitle
    }

    func createMainWordListBuilder() -> MainWordListBuilder {
        MainWordListBuilderImpl(appConfigs: appConfigs,
                                coreRouter: coreRouter,
                                routingButtonTitle: routingButtonTitle)
    }
}
