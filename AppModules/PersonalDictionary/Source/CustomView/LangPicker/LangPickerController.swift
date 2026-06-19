//
//  PickerController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

/// Data source for the language picker element.
final class LangPickerController: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

    /// List of languages
    let langs: [Lang]

    /// Initializer
    /// - Parameters:
    ///  - langs: list of languages to choose from.
    init(langs: [Lang]) {
        self.langs = langs
    }

    /// UIPickerViewDataSource methods:

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
