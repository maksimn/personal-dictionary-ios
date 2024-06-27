//
//  LangPickerView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import CoreModule
import UDF
import UIKit

final class LangPickerView: UIView, ViewComponent {

    var props = LangPickerState() {
        didSet {
            guard let lang = props.value?.lang else { return }

            langPicker.select(lang)
        }
    }

    var disposer = Disposer()

    private let params: LangPickerParams
    private let store: Store<LangPickerState>
    private let theme: Theme
    private let logger: Logger

    private lazy var langPicker = LangPicker(
        params: params,
        theme: theme,
        onSelect: { [weak self] in
            self?.onSelect(lang: $0)
        }
    )

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры представления выбора языка.
    init(params: LangPickerParams, store: Store<LangPickerState>, theme: Theme, logger: Logger) {
        self.params = params
        self.store = store
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

    private func initView() {
        addSubview(langPicker)
        langPicker.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }

    private func onSelect(lang: Lang) {
        store.dispatch(LangPickerAction.langSelected(lang))
        store.dispatch(LangPickerAction.hide)
    }
}
