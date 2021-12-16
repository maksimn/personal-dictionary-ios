//
//  PersonalDictionaryAppBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

final class PersonalDictionaryAppBuilderImpl: PersonalDictionaryAppBuilder {

    private let coreRouter: CoreRouter?
    private let routingButtonTitle: String

    init(coreRouter: CoreRouter?,
         routingButtonTitle: String) {
        self.coreRouter = coreRouter
        self.routingButtonTitle = routingButtonTitle
    }

    func build() -> PersonalDictionaryApp {
        let configBuilder = ConfigBuilderImpl(coreRouter: coreRouter,
                                              routingButtonTitle: routingButtonTitle)

        return PersonalDictionaryAppImpl(configBuilder: configBuilder)
    }
}
