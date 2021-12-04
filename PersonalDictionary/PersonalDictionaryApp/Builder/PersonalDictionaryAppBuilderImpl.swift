//
//  PersonalDictionaryAppBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

final class PersonalDictionaryAppBuilderImpl: PersonalDictionaryAppBuilder {

    private let configBuilder = ConfigBuilderImpl()

    func build() -> PersonalDictionaryApp {
        PersonalDictionaryAppImpl(configBuilder: configBuilder)
    }
}
