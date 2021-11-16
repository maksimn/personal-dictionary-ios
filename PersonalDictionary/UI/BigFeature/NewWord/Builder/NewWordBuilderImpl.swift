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
    private let langPickerBuilder: LangPickerBuilder

    // Переделать: 1) langPickerBuilder является внутренней зависимостью фичи NewWord,
    // он должен инстанцироваться внутри NewWordBuilderImpl, а не передаваться извне.
    // 2) Убрать NotificationCenter, перейти к использованию делегатов
    // NewWordListener и LangPickerListener.
    init(appViewConfigs: AppViewConfigs,
         langRepository: LangRepository,
         notificationCenter: NotificationCenter,
         langPickerBuilder: LangPickerBuilder) {
        self.appViewConfigs = appViewConfigs
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
