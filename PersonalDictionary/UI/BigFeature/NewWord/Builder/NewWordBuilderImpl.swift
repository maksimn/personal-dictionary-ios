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
            styles: NewWordViewStyles(backgroundColor: globalViewSettings.appBackgroundColor)
        )
    }()

    private let globalViewSettings: GlobalViewSettings
    private let langRepository: LangRepository
    private let notificationCenter: NotificationCenter
    private let langPickerBuilder: LangPickerBuilder

    init(globalViewSettings: GlobalViewSettings,
         langRepository: LangRepository,
         notificationCenter: NotificationCenter,
         langPickerBuilder: LangPickerBuilder) {
        self.globalViewSettings = globalViewSettings
        self.langRepository = langRepository
        self.notificationCenter = notificationCenter
        self.langPickerBuilder = langPickerBuilder
    }

    func build() -> NewWordMVVM {
        NewWordMVVMImpl(langRepository: langRepository,
                        notificationCenter: notificationCenter,
                        viewParams: newWordViewParams,
                        langPickerBuilder: langPickerBuilder)
    }
}
