//
//  LangPickerViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import RxCocoa

/// Реализация модели представления Выбора языка.
final class LangPickerViewModelImpl: LangPickerViewModel {

    private let model: LangPickerModel

    /// Инициализатор.
    /// - Parameters:
    ///  - model: модель фичи "Выбор языка"
    init(model: LangPickerModel) {
        self.model = model
    }

    /// Данные модели представления.
    let langSelectorData = BehaviorRelay<LangSelectorData?>(value: nil)

    /// Оповестить о выбранном языке.
    /// - Parameters:
    ///  - data: данные о выбранном языке.
    func notifyAboutSelectedLang(_ data: LangSelectorData) {
        model.listener?.onLangSelected(data)
    }
}
