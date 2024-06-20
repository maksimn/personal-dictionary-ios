//
//  LangPickerView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import CoreModule
import UDF
import UIKit

final class LangPickerView: UIView, ViewStateSetter {

    private let params: LangPickerParams
    private let udf: LangPickerUDF
    private let theme: Theme
    private let logger: Logger

    private lazy var langPicker = LangPicker(
        params: params,
        theme: theme,
        onSelect: { [weak self] lang in
            self?.udf.onSelect(lang)
        }
    )

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры представления выбора языка.
    init(params: LangPickerParams, udf: LangPickerUDF, theme: Theme, logger: Logger) {
        self.params = params
        self.udf = udf
        self.theme = theme
        self.logger = logger
        super.init(frame: .zero)
        initView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        logger.log(dismissedFeatureName: "LangPicker")
    }
    
    func setViewState(_ state: LangPickerState) {
        isHidden = state.isHidden
        langPicker.select(state.lang)
    }

    private func initView() {
        addSubview(langPicker)
        langPicker.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
    }
}
