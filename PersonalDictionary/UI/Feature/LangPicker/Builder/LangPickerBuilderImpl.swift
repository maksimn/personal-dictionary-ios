//
//  LangPickerBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

final class LangPickerBuilderImpl: LangPickerBuilder {

    private let dependencies: LangPickerDependencies

    init(allLangs: [Lang],
         appViewConfigs: AppViewConfigs) {
        dependencies = LangPickerDependencies(allLangs: allLangs,
                                              appViewConfigs: appViewConfigs)
    }

    func build() -> LangPickerMVVM {
        LangPickerMVVMImpl(allLangs: dependencies.allLangs,
                           viewParams: dependencies.viewParams)
    }
}
