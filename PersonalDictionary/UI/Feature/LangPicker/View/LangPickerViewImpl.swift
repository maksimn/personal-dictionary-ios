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

    private let params: LangPickerPopupParams

    init(params: LangPickerViewParams) {
        self.params = params
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(langSelectorData: LangSelectorData) {
        langPickerPopup = LangPickerPopup(params: params,
                                          initialLang: langSelectorData.selectedLang,
                                          allLangs: langSelectorData.allLangs,
                                          onSelectLang: { [weak self] lang in
                                            self?.onSelectLang(lang)
                                          })
        addSubview(langPickerPopup ?? UIView())
        langPickerPopup?.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
    }

    private func onSelectLang(_ lang: Lang) {
        viewModel?.sendSelectedLang(lang)
    }
}
