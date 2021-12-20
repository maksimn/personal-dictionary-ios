//
//  ConfigBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import CoreModule

final class ConfigBuilderImpl: ConfigBuilder {

    private let appConfigs: AppConfigs

    init(appParams: PersonalDictionaryAppParams) {
        appConfigs = ConfigDependencies(appParams: appParams).appConfigs
    }

    func createMainWordListBuilder() -> MainWordListBuilder {
        MainWordListBuilderImpl(appConfigs: appConfigs)
    }
}
