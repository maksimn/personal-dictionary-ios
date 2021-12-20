//
//  PersonalDictionaryAppBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

public final class PersonalDictionaryAppBuilderImpl: PersonalDictionaryAppBuilder {

    private let appParams: PersonalDictionaryAppParams

    public init(appParams: PersonalDictionaryAppParams) {
        self.appParams = appParams
    }

    public func build() -> PersonalDictionaryApp {
        PersonalDictionaryAppImpl(configBuilder: ConfigBuilderImpl(appParams: appParams))
    }
}
