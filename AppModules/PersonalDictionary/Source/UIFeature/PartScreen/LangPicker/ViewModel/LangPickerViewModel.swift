//
//  LangPickerViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import RxCocoa

/// Модель представления Выбора языка.
protocol LangPickerViewModel: AnyObject {

    /// Данные модели представления.
    var langSelectorData: BehaviorRelay<LangSelectorData?> { get }

    /// Оповестить о выбранном языке.
    /// - Parameters:
    ///  - data: данные о выбранном языке.
    func notifyAboutSelectedLang(_ data: LangSelectorData)
}
