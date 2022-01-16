//
//  LangPickerViewImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import UIKit

typealias LangPickerViewParams = LangPickerPopupParams

final class LangPickerViewImpl: UIView, LangPickerView {

    /// Модель представления Выбора языка.
    var viewModel: LangPickerViewModel?

    private var langPickerPopup: LangPickerPopup?

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры представления выбора языка.
    init(params: LangPickerViewParams) {
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

    /// Задать данные для отображения в представлении.
    /// - Parameters:
    ///  - langSelectorData: данные для выбора языка.
    func set(langSelectorData: LangSelectorData) {
        langPickerPopup?.selectLang(langSelectorData.selectedLang)
    }

    private func onSelectLang(_ lang: Lang) {
        viewModel?.sendSelectedLang(lang)
    }
}
