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
    private let notificationCenter: NotificationCenter
    private lazy var langPickerBuilder = {
        LangPickerBuilderImpl(allLangs: langRepository.allLangs, appViewConfigs: appViewConfigs)
    }()

    // Переделать:
    // 2) Убрать NotificationCenter, перейти к использованию делегатов
    // NewWordListener и LangPickerListener.
    init(appViewConfigs: AppViewConfigs,
         langRepository: LangRepository,
         notificationCenter: NotificationCenter) {
        self.appViewConfigs = appViewConfigs
        self.langRepository = langRepository
        self.notificationCenter = notificationCenter
    }

    func build() -> NewWordMVVM {
        NewWordMVVMImpl(langRepository: langRepository,
                        notificationCenter: notificationCenter,
                        viewParams: newWordViewParams,
                        langPickerBuilder: langPickerBuilder)
    }
}
