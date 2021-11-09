//
//  LangPickerViewImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import UIKit

final class LangPickerViewImpl: UIView, LangPickerView {

    var viewModel: LangPickerViewModel?

    var langPickerPopup: LangPickerPopup?

    func set(langSelectorData: LangSelectorData) {
        langPickerPopup = LangPickerPopup(langPickerController: LangPickerController(langs: langSelectorData.allLangs),
                                          onSelectLang: { [weak self] lang in
                                            self?.onSelectLang(lang)
                                          },
                                          selectButtonTitle: NSLocalizedString("Select", comment: ""),
                                          backgroundColor: pdGlobalSettings.appBackgroundColor,
                                          isHidden: false)
        langPickerPopup?.select(lang: langSelectorData.lang)
        addSubview(langPickerPopup ?? UIView())
        langPickerPopup?.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
    }

    func onSelectLang(_ lang: Lang) {
        viewModel?.sendSelectedLang(lang)
    }
}
