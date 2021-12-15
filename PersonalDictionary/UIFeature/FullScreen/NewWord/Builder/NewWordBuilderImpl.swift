//
//  NewWordBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

final class NewWordBuilderImpl: NewWordBuilder {

    private let dependencies: NewWordDependencies

    init(appViewConfigs: AppViewConfigs,
         langRepository: LangRepository) {
        dependencies = NewWordDependencies(appViewConfigs: appViewConfigs,
                                           langRepository: langRepository)
    }

    func build() -> NewWordMVVM {
        NewWordMVVMImpl(langRepository: dependencies.langRepository,
                        wordItemStream: dependencies.wordItemStream,
                        viewParams: dependencies.viewParams,
                        langPickerBuilder: dependencies.langPickerBuilder)
    }
}
