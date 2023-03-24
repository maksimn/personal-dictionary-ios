//
//  LangPickerViewImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import CoreModule
import RxSwift
import UIKit

final class LangPickerView: UIView {

    private let params: LangPickerParams
    private let viewModel: LangPickerViewModel
    private let theme: Theme
    private let logger: Logger
    private let disposeBag = DisposeBag()

    private lazy var langPicker = LangPicker(
        params: params,
        theme: theme,
        onSelect: { [weak self] lang in
            self?.viewModel.onSelect(lang)
        }
    )

    private let featureName = "PersonalDictionary.LangPicker"

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры представления выбора языка.
    ///  - viewModel: модель представления.
    init(params: LangPickerParams, viewModel: LangPickerViewModel, theme: Theme, logger: Logger) {
        self.params = params
        self.viewModel = viewModel
        self.theme = theme
        self.logger = logger
        super.init(frame: .zero)
        initView()
        bindToViewModel()
        logger.log(installedFeatureName: featureName)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        logger.log(dismissedFeatureName: featureName)
    }

    private func initView() {
        addSubview(langPicker)
        langPicker.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
    }

    private func bindToViewModel() {
        viewModel.state.subscribe(onNext: { [weak self] state in
            guard let state = state else { return }

            self?.isHidden = state.isHidden
            self?.langPicker.select(state.lang)
        }).disposed(by: disposeBag)
    }
}
