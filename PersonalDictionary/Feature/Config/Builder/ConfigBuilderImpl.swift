//
//  ConfigBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

final class ConfigBuilderImpl: ConfigBuilder {

    func build() -> ConfigGraph {
        ConfigGraphImpl()
    }
}
