//
//  NewWordBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import Foundation

final class NewWordBuilderImpl: NewWordBuilder {

    private lazy var newWordViewParams: NewWordViewParams = {
        NewWordViewParams(
            staticContent: NewWordViewStaticContent(
                selectButtonTitle: NSLocalizedString("Select", comment: ""),
                arrowText: NSLocalizedString("⇋", comment: ""),
                okText: NSLocalizedString("OK", comment: ""),
                textFieldPlaceholder: NSLocalizedString("Enter a new word", comment: "")
            ),
            styles: NewWordViewStyles(backgroundColor: appViewConfigs.appBackgroundColor)
        )
    }()

    private let appViewConfigs: AppViewConfigs
    private let langRepository: LangRepository
    private lazy var langPickerBuilder = {
        LangPickerBuilderImpl(allLangs: langRepository.allLangs, appViewConfigs: appViewConfigs)
    }()
    private let wordItemStream: NewWordItemStream

    init(appViewConfigs: AppViewConfigs,
         langRepository: LangRepository,
         wordItemStream: NewWordItemStream) {
        self.appViewConfigs = appViewConfigs
        self.langRepository = langRepository
        self.wordItemStream = wordItemStream
    }

    func build() -> NewWordMVVM {
        NewWordMVVMImpl(langRepository: langRepository,
                        wordItemStream: wordItemStream,
                        viewParams: newWordViewParams,
                        langPickerBuilder: langPickerBuilder)
    }
}
