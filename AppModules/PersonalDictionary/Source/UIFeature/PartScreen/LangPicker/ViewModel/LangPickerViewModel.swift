//
//  LangPickerViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import RxSwift

/// Модель представления Выбора языка.
protocol LangPickerViewModel: AnyObject {

    /// Данные модели представления.
    var langSelectorData: Observable<LangSelectorData> { get }

    /// Обновить сведения о выбранном языке.
    /// - Parameters:
    ///  - data: данные о выбранном языке.
    func updateSelectedLang(_ data: LangSelectorData)

    /// Оповестить о выбранном языке.
    /// - Parameters:
    ///  - data: данные о выбранном языке.
    func notifyAboutSelectedLang(_ data: LangSelectorData)
}
