//
//  LangPickerBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import Foundation

final class LangPickerBuilderImpl: LangPickerBuilder {

    private let viewParams = LangPickerViewParams(
        staticContent: LangPickerViewStaticContent(
            selectButtonTitle: NSLocalizedString("Select", comment: "")
        ),
        styles: LangPickerViewStyles(
            backgroundColor: pdGlobalSettings.appBackgroundColor
        )
    )

    private let allLangs: [Lang]
    private let notificationCenter: NotificationCenter

    init(allLangs: [Lang],
         notificationCenter: NotificationCenter) {
        self.allLangs = allLangs
        self.notificationCenter = notificationCenter
    }

    func build(with initLang: Lang, selectedLangType: SelectedLangType) -> LangPickerMVVM {
        LangPickerMVVMImpl(with: LangSelectorData(allLangs: allLangs,
                                                  selectedLang: initLang,
                                                  selectedLangType: selectedLangType),
                           notificationCenter: notificationCenter,
                           viewParams: viewParams)
    }
}
