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
        viewParams = NewWordViewParams(
            staticContent: NewWordViewStaticContent(
                selectButtonTitle: NSLocalizedString("Select", comment: ""),
                arrowText: NSLocalizedString("⇋", comment: ""),
                okText: NSLocalizedString("OK", comment: ""),
                textFieldPlaceholder: NSLocalizedString("Enter a new word", comment: "")
            ),
            styles: NewWordViewStyles(backgroundColor: appViewConfigs.appBackgroundColor)
        )
        self.langRepository = langRepository
        langPickerBuilder = LangPickerBuilderImpl(allLangs: langRepository.allLangs, appViewConfigs: appViewConfigs)
        wordItemStream = WordItemStreamImpl.instance
    }
}
