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

    public init(coreRouter: CoreRouter?,
                routingButtonTitle: String) {
        self.coreRouter = coreRouter
        self.routingButtonTitle = routingButtonTitle
    }
}
