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
                backgroundColor: appViewConfigs.appBackgroundColor
            )
        )
    }()

    private let allLangs: [Lang]
    private let appViewConfigs: AppViewConfigs

    init(allLangs: [Lang],
         appViewConfigs: AppViewConfigs) {
        self.allLangs = allLangs
        self.appViewConfigs = appViewConfigs
    }

    func build(with initLang: Lang,
               selectedLangType: SelectedLangType,
               listener: LangPickerListener?) -> LangPickerMVVM {
        LangPickerMVVMImpl(with: LangSelectorData(allLangs: allLangs,
                                                  selectedLang: initLang,
                                                  selectedLangType: selectedLangType),
                           listener: listener,
                           viewParams: viewParams)
    }
}
