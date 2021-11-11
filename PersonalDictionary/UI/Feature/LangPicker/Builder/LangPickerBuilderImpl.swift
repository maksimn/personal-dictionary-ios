//
//  LangPickerBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import Foundation

final class LangPickerBuilderImpl: LangPickerBuilder {

    private lazy var viewParams = {
        LangPickerViewParams(
            staticContent: LangPickerViewStaticContent(
                selectButtonTitle: NSLocalizedString("Select", comment: "")
            ),
            styles: LangPickerViewStyles(
                backgroundColor: globalViewSettings.appBackgroundColor
            )
        )
    }()

    private let allLangs: [Lang]
    private let notificationCenter: NotificationCenter
    private let globalViewSettings: GlobalViewSettings

    init(allLangs: [Lang],
         notificationCenter: NotificationCenter,
         globalViewSettings: GlobalViewSettings) {
        self.allLangs = allLangs
        self.notificationCenter = notificationCenter
        self.globalViewSettings = globalViewSettings
    }

    func build(with initLang: Lang, selectedLangType: SelectedLangType) -> LangPickerMVVM {
        LangPickerMVVMImpl(with: LangSelectorData(allLangs: allLangs,
                                                  selectedLang: initLang,
                                                  selectedLangType: selectedLangType),
                           notificationCenter: notificationCenter,
                           viewParams: viewParams)
    }
}
