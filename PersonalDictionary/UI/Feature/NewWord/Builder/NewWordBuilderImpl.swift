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
            styles: NewWordViewStyles(backgroundColor: globalSettings.appBackgroundColor)
        )
    }()

    private let globalSettings: PDGlobalSettings
    private let langRepository: LangRepository
    private let notificationCenter: NotificationCenter
    private let langPickerBuilder: LangPickerBuilder

    init(globalSettings: PDGlobalSettings,
         langRepository: LangRepository,
         notificationCenter: NotificationCenter,
         langPickerBuilder: LangPickerBuilder) {
        self.globalSettings = globalSettings
        self.langRepository = langRepository
        self.notificationCenter = notificationCenter
        self.langPickerBuilder = langPickerBuilder
    }

    func build() -> NewWordMVVM {
        NewWordMVVMImpl(langRepository: langRepository,
                        notificationCenter: NotificationCenter.default,
                        viewParams: newWordViewParams,
                        langPickerBuilder: langPickerBuilder)
    }
}
