//
//  LangPickerPopup.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 03.10.2021.
//

import SnapKit
import UIKit

/// "Всплывающее" представление для выбора языка.
final class LangPickerPopup: UIView {

    private let pickerView = UIPickerView()

    private let selectButton = UIButton()

    private let params: LangPickerPopupParams

    private let langPickerController: LangPickerController

    private let onSelectLang: ((Lang) -> Void)?

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры представления;
    ///  - onSelectLang: callback, который вызывается при нажатии кнопки "Выбрать" на попапе.
    init(params: LangPickerPopupParams,
         onSelectLang: ((Lang) -> Void)?) {
        self.params = params
        self.langPickerController = LangPickerController(langs: params.langs)
        self.onSelectLang = onSelectLang
        super.init(frame: .zero)
        self.backgroundColor = Theme.data.backgroundColor
        layer.cornerRadius = 16
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Выделить выбранный язык в представлении попапа.
    /// - Parameters:
    ///  - lang: выбранный язык.
    func selectLang(_ lang: Lang) {
        guard let row = langPickerController.langs.firstIndex(where: { $0.id == lang.id }) else { return }

        pickerView.selectRow(row, inComponent: 0, animated: false)
    }

    @objc
    private func onSelectButtonTap() {
        let row = pickerView.selectedRow(inComponent: 0)
        let lang = langPickerController.langs[row]

        onSelectLang?(lang)
    }

    // MARK: - Layout

    private func initViews() {
        addSubview(pickerView)
        addSubview(selectButton)
        initLangPickerView()
        initSelectButton()
    }

    private func initLangPickerView() {
        pickerView.dataSource = langPickerController
        pickerView.delegate = langPickerController
        pickerView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 12, left: 16, bottom: 44, right: 16))
        }
    }

    private func initSelectButton() {
        selectButton.setTitle(params.selectButtonTitle, for: .normal)
        selectButton.setTitleColor(.white, for: .normal)
        selectButton.backgroundColor = .darkGray
        selectButton.layer.cornerRadius = 8
        selectButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        selectButton.addTarget(self, action: #selector(onSelectButtonTap), for: .touchUpInside)
        selectButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self).offset(-16)
            make.centerX.equalTo(self)
            make.height.equalTo(30)
        }
    }
}
