//
//  LangPickerPopupParams.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import UIKit

/// Параметры "всплывающего" представления для выбора языка.
struct LangPickerPopupParams {

    /// Надпись на кнопке "выбрать"
    let selectButtonTitle: String

    /// Список языков для выбора
    let langs: [Lang]
}
