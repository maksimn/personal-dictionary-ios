//
//  PickerController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

/// Источник данных для представления для выбора языка.
final class LangPickerController: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

    /// Список языков
    let langs: [Lang]

    /// Инициализатор
    /// - Parameters:
    ///  - langs: список языков.
    init(langs: [Lang]) {
        self.langs = langs
    }

    /// Методы UIPickerViewDataSource:

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        langs.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        langs[row].name
    }
}
