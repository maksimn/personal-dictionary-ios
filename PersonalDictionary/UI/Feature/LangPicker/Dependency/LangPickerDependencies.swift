//
//  LangPickerDependencies.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.12.2021.
//

import Foundation

final class LangPickerDependencies {

    let allLangs: [Lang]
    let viewParams: LangPickerViewParams

    init(allLangs: [Lang],
         appViewConfigs: AppViewConfigs) {
        self.allLangs = allLangs
        viewParams = LangPickerViewParams(
            staticContent: LangPickerPopupStaticContent(
                selectButtonTitle: NSLocalizedString("Select", comment: "")
            ),
            styles: LangPickerPopupStyles(
                backgroundColor: appViewConfigs.appBackgroundColor
            )
        )
    }
}
