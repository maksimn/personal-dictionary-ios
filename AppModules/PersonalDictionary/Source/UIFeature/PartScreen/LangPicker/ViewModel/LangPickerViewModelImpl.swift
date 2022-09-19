//
//  LangPickerViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import RxCocoa

/// Реализация модели представления Выбора языка.
final class LangPickerViewModelImpl: LangPickerViewModel {

    /// Данные модели представления.
    let state = BehaviorRelay<LangPickerState?>(value: nil)

    private let model: LangPickerModel

    /// Инициализатор.
    /// - Parameters:
    ///  - model: модель фичи "Выбор языка"
    init(model: LangPickerModel) {
        self.model = model
    }

    func update(selectedLang: Lang) {
        model.update(selectedLang: selectedLang)
    }
}
