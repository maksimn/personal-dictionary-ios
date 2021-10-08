//
//  LangPickerPopup.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 03.10.2021.
//

import UIKit

final class LangPickerPopup: UIView {

    let pickerView = UIPickerView()

    let selectButton = UIButton()

    let selectButtonTitle: String

    let langPickerController: LangPickerController

    let onSelectLang: ((Lang) -> Void)?

    init(langPickerController: LangPickerController,
         onSelectLang: ((Lang) -> Void)?,
         selectButtonTitle: String,
         backgroundColor: UIColor,
         isHidden: Bool) {
        self.selectButtonTitle = selectButtonTitle
        self.langPickerController = langPickerController
        self.onSelectLang = onSelectLang
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 16
        self.isHidden = isHidden
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func select(lang: Lang) {
        guard let row = langPickerController.langs.firstIndex(where: { $0.id == lang.id }) else { return }

        pickerView.selectRow(row, inComponent: 0, animated: false)
    }

    @objc
    func onSelectButtonTap() {
        let row = pickerView.selectedRow(inComponent: 0)
        let lang = langPickerController.langs[row]

        onSelectLang?(lang)
    }
}
