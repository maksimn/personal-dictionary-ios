//
//  LangPickerPopup.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 03.10.2021.
//

import SnapKit
import UIKit

/// Параметры "всплывающего" представления для выбора языка.
struct LangPickerParams {

    /// Надпись на кнопке "выбрать"
    let title: String

    /// Список языков для выбора
    let langs: [Lang]
}

/// Элемент для выбора языка.
final class LangPicker: UIView {

    private let pickerView = UIPickerView()
    private let selectButton = UIButton()
    private let params: LangPickerParams
    private let onSelect: ((Lang) -> Void)?
    private lazy var langPickerController = LangPickerController(langs: params.langs)
    private let theme: Theme

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры представления;
    ///  - onSelectLang: callback, который вызывается при нажатии кнопки "Выбрать" на попапе.
    init(params: LangPickerParams,
         theme: Theme,
         onSelect: ((Lang) -> Void)?) {
        self.params = params
        self.theme = theme
        self.onSelect = onSelect
        super.init(frame: .zero)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Выделить выбранный язык в представлении.
    /// - Parameters:
    ///  - lang: выбранный язык.
    func select(_ lang: Lang) {
        guard let row = langPickerController.langs.firstIndex(where: { $0.id == lang.id }) else { return }

        pickerView.selectRow(row, inComponent: 0, animated: false)
    }

    @objc
    private func onSelectButtonTap() {
        let row = pickerView.selectedRow(inComponent: 0)
        let lang = langPickerController.langs[row]

        onSelect?(lang)
    }

    // MARK: - Layout

    private func initViews() {
        backgroundColor = theme.backgroundColor
        layer.cornerRadius = 16
        initLangPickerView()
        initSelectButton()
    }

    private func initLangPickerView() {
        addSubview(pickerView)
        pickerView.dataSource = langPickerController
        pickerView.delegate = langPickerController
        pickerView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 12, left: 16, bottom: 44, right: 16))
        }
    }

    private func initSelectButton() {
        addSubview(selectButton)
        selectButton.setTitle(params.title, for: .normal)
        selectButton.setTitleColor(.white, for: .normal)
        selectButton.backgroundColor = .darkGray
        selectButton.layer.cornerRadius = 8
        selectButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        selectButton.addTarget(self, action: #selector(onSelectButtonTap), for: .touchUpInside)
        selectButton.snp.makeConstraints { make in
            make.bottom.equalTo(self).offset(-16)
            make.centerX.equalTo(self)
            make.height.equalTo(30)
        }
    }
}
