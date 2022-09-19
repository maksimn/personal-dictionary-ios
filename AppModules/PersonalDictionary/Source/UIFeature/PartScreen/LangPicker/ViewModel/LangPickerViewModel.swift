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
    var state: BehaviorRelay<LangPickerState?> { get }

    func update(selectedLang: Lang)
}
