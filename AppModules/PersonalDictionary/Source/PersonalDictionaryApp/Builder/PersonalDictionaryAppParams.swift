//
//  PersonalDictionaryAppParams.swift
//  SuperList
//
//  Created by Maxim Ivanov on 20.12.2021.
//

import CoreModule

public struct PersonalDictionaryAppParams {

    public let coreRouter: CoreRouter?
    public let routingButtonTitle: String
    public let coreModuleParams: CoreModuleParams

    public init(coreRouter: CoreRouter?,
                routingButtonTitle: String,
                coreModuleParams: CoreModuleParams) {
        self.coreRouter = coreRouter
        self.routingButtonTitle = routingButtonTitle
        self.coreModuleParams = coreModuleParams
    }
}
