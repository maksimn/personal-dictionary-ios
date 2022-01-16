//
//  NewWordDependencies.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.12.2021.
//

import Foundation

final class NewWordDependencies {

    let langRepository: LangRepository

    let viewParams: NewWordViewParams

    let langPickerBuilder: LangPickerBuilder

    let wordItemStream: NewWordItemStream

    init(appViewConfigs: AppViewConfigs,
         langRepository: LangRepository) {
        let bundle = Bundle(for: type(of: self))

        viewParams = NewWordViewParams(
            selectButtonTitle: bundle.moduleLocalizedString("Select"),
            arrowText: bundle.moduleLocalizedString("⇋"),
            okText: bundle.moduleLocalizedString("OK"),
            textFieldPlaceholder: bundle.moduleLocalizedString("Enter a new word"),
            backgroundColor: appViewConfigs.backgroundColor
        )
        self.langRepository = langRepository
        langPickerBuilder = LangPickerBuilderImpl(allLangs: langRepository.allLangs, appViewConfigs: appViewConfigs)
        wordItemStream = WordItemStreamImpl.instance
    }
}
