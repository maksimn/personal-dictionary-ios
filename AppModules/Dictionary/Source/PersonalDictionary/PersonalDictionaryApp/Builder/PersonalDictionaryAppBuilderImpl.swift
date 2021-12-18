//
//  PersonalDictionaryAppBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

import CoreModule

public final class PersonalDictionaryAppBuilderImpl: PersonalDictionaryAppBuilder {

    private let coreRouter: CoreRouter?
    private let routingButtonTitle: String

    public init(coreRouter: CoreRouter?,
                routingButtonTitle: String) {
        self.coreRouter = coreRouter
        self.routingButtonTitle = routingButtonTitle
    }

    public func build() -> PersonalDictionaryApp {
        let configBuilder = ConfigBuilderImpl(coreRouter: coreRouter,
                                              routingButtonTitle: routingButtonTitle)

        return PersonalDictionaryAppImpl(configBuilder: configBuilder)
    }
}
