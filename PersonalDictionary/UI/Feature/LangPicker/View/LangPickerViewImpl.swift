//
//  LangPickerViewImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import UIKit

final class LangPickerViewImpl: UIView, LangPickerView {

    var viewModel: LangPickerViewModel?

    private var langPickerPopup: LangPickerPopup?

    func set(langSelectorData: LangSelectorData) {
        langPickerPopup = LangPickerPopup(initialLang: langSelectorData.lang,
                                          langPickerController: LangPickerController(langs: langSelectorData.allLangs),
                                          onSelectLang: { [weak self] lang in
                                            self?.onSelectLang(lang)
                                          },
                                          selectButtonTitle: NSLocalizedString("Select", comment: ""),
                                          backgroundColor: pdGlobalSettings.appBackgroundColor)
        addSubview(langPickerPopup ?? UIView())
        langPickerPopup?.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
    }

    func onSelectLang(_ lang: Lang) {
        viewModel?.sendSelectedLang(lang)
    }
}
