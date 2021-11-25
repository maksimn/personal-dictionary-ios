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

    init(appViewConfigs: AppViewConfigs,
         langRepository: LangRepository) {
        self.appViewConfigs = appViewConfigs
        self.langRepository = langRepository
    }

    func build(withListener listener: NewWordListener?) -> NewWordMVVM {
        NewWordMVVMImpl(langRepository: langRepository,
                        listener: listener,
                        viewParams: newWordViewParams,
                        langPickerBuilder: langPickerBuilder)
    }
}
