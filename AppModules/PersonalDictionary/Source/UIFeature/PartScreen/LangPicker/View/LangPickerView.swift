//
//  LangPickerViewImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import RxSwift
import UIKit

final class LangPickerView: UIView {

    private let params: LangPickerPopupParams
    private let viewModel: LangPickerViewModel
    private let disposeBag = DisposeBag()

    private lazy var langPickerPopup = LangPickerPopup(
        params: params,
        onSelectLang: { [weak self] lang in
            self?.viewModel.onLangSelected(lang)
        }
    )

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры представления выбора языка.
    ///  - viewModel: модель представления.
    init(params: LangPickerPopupParams,
         viewModel: LangPickerViewModel) {
        self.params = params
        self.viewModel = viewModel
        super.init(frame: .zero)
        initView()
        bindToViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initView() {
        addSubview(langPickerPopup)
        langPickerPopup.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
    }

    private func bindToViewModel() {
        viewModel.state.subscribe(onNext: { [weak self] state in
            guard let state = state else { return }
            
            self?.langPickerPopup.selectLang(state.lang)
        }).disposed(by: disposeBag)
    }
}
