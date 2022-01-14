//
//  LangPickerPopupParams.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import UIKit

struct LangPickerPopupStaticContent {

    /// Надпись на кнопке "выбрать"
    let selectButtonTitle: String

    /// Список языков для выбора
    let langs: [Lang]
}

struct LangPickerPopupStyles {

    /// Цвет фона представления выбора языка
    let backgroundColor: UIColor
}

/// Параметры "всплывающего" представления для выбора языка.
typealias LangPickerPopupParams = ViewParams<LangPickerPopupStaticContent, LangPickerPopupStyles>
