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

    private let params: LangPickerViewParams

    init(params: LangPickerViewParams) {
        self.params = params
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(langSelectorData: LangSelectorData) {
        langPickerPopup = LangPickerPopup(initialLang: langSelectorData.selectedLang,
                                          langPickerController: LangPickerController(langs: langSelectorData.allLangs),
                                          onSelectLang: { [weak self] lang in
                                            self?.onSelectLang(lang)
                                          },
                                          selectButtonTitle: params.staticContent.selectButtonTitle,
                                          backgroundColor: params.styles.backgroundColor)
        addSubview(langPickerPopup ?? UIView())
        langPickerPopup?.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
    }

    func onSelectLang(_ lang: Lang) {
        viewModel?.sendSelectedLang(lang)
    }
}
