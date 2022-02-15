//
//  LangPickerViewImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import RxSwift
import UIKit

typealias LangPickerViewParams = LangPickerPopupParams

final class LangPickerViewImpl: UIView {

    private let viewModel: LangPickerViewModel
    private let disposeBag = DisposeBag()

    private var langPickerPopup: LangPickerPopup?
    private var selectedLangType: SelectedLangType?

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры представления выбора языка.
    ///  - viewModel: модель представления.
    init(params: LangPickerViewParams, viewModel: LangPickerViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        langPickerPopup = LangPickerPopup(params: params,
                                          onSelectLang: { [weak self] lang in
                                            self?.onSelectLang(lang)
                                          })
        addSubview(langPickerPopup ?? UIView())
        langPickerPopup?.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
        bindToViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindToViewModel() {
        viewModel.langSelectorData.subscribe(onNext: { [weak self] langSelectorData in
            self?.selectedLangType = langSelectorData.selectedLangType
            self?.langPickerPopup?.selectLang(langSelectorData.selectedLang)
        }).disposed(by: disposeBag)
    }

    private func onSelectLang(_ lang: Lang) {
        isHidden = true
        guard let selectedLangType = selectedLangType else { return }

        viewModel.notifyAboutSelectedLang(LangSelectorData(selectedLang: lang, selectedLangType: selectedLangType))
    }
}
