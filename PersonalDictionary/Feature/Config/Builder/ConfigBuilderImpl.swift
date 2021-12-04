//
//  ConfigBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

final class ConfigBuilderImpl: ConfigBuilder {

    private let appConfigs = ConfigDependencies().appConfigs

    func createMainWordListBuilder() -> MainWordListBuilder {
        MainWordListBuilderImpl(appConfigs: appConfigs)
    }
}
