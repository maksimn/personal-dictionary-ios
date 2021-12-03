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
            staticContent: LangPickerPopupStaticContent(
                selectButtonTitle: NSLocalizedString("Select", comment: "")
            ),
            styles: LangPickerPopupStyles(
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

    func build() -> LangPickerMVVM {
        LangPickerMVVMImpl(allLangs: allLangs,
                           viewParams: viewParams)
    }
}
