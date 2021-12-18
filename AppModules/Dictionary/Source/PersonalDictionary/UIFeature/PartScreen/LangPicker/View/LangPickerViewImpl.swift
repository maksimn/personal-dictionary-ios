//
//  LangPickerViewImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import UIKit

typealias LangPickerViewParams = LangPickerPopupParams

final class LangPickerViewImpl: UIView, LangPickerView {

    var viewModel: LangPickerViewModel?

    private var langPickerPopup: LangPickerPopup?

    init(params: LangPickerViewParams, allLangs: [Lang]) {
        super.init(frame: .zero)
        langPickerPopup = LangPickerPopup(params: params,
                                          onSelectLang: { [weak self] lang in
                                            self?.onSelectLang(lang)
                                          })
        addSubview(langPickerPopup ?? UIView())
        langPickerPopup?.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(langSelectorData: LangSelectorData) {
        langPickerPopup?.selectLang(langSelectorData.selectedLang)
    }

    private func onSelectLang(_ lang: Lang) {
        viewModel?.sendSelectedLang(lang)
    }
}
