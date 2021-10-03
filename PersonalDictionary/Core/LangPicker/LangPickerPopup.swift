//
//  LangPickerPopup.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 03.10.2021.
//

import UIKit

final class LangPickerPopup: UIView {

    let pickerView = UIPickerView()
    let langPickerController = LangPickerController()

    let selectButton = UIButton()

    var onSelectLang: ((Lang) -> Void)?

    init() {
        super.init(frame: .zero)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func select(lang: Lang) {
        guard let row = langPickerController.langs.firstIndex(where: { $0.name == lang.name }) else { return }

        pickerView.selectRow(row, inComponent: 0, animated: false)
    }

    @objc
    func onSelectButtonTap() {
        let row = pickerView.selectedRow(inComponent: 0)
        let lang = langPickerController.langs[row]

        onSelectLang?(lang)
    }
}
