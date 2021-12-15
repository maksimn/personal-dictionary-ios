//
//  PersonalDictionaryAppBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

final class PersonalDictionaryAppBuilderImpl: PersonalDictionaryAppBuilder {

    private let superAppRouter: SuperAppRouter?
    private let superAppRoutingButtonTitle: String

    init(superAppRouter: SuperAppRouter?,
         superAppRoutingButtonTitle: String) {
        self.superAppRouter = superAppRouter
        self.superAppRoutingButtonTitle = superAppRoutingButtonTitle
    }

    func build() -> PersonalDictionaryApp {
        let configBuilder = ConfigBuilderImpl(superAppRouter: superAppRouter,
                                              superAppRoutingButtonTitle: superAppRoutingButtonTitle)

        return PersonalDictionaryAppImpl(configBuilder: configBuilder)
    }
}
