//
//  LangPickerViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

/// Реализация модели представления Выбора языка.
final class LangPickerViewModelImpl: LangPickerViewModel {

    /// Данные модели представления.
    let state = BindableLangPickerState(value: nil)

    weak var listener: LangPickerListener?

    func onSelect(_ lang: Lang) {
        guard let oldState = state.value else { return }
        var newState = oldState

        newState.lang = lang
        newState.isHidden = true

        listener?.onLangPickerStateChanged(newState)
    }
}
