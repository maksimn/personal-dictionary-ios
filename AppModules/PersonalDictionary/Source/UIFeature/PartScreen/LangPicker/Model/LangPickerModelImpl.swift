//
//  LangPickerModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

/// Реализация модели выбора языка.
final class LangPickerModelImpl: LangPickerModel {

    /// Данные о выбранном языке.
    var state: LangPickerState? {
        didSet {
            if viewModel == nil {
                viewModel = viewModelBlock()
            }
            viewModel?.state.accept(state)
        }
    }

    /// Делегат события выбора языка.
    weak var listener: LangPickerListener?

    private let viewModelBlock: () -> LangPickerViewModel?
    private weak var viewModel: LangPickerViewModel?

    init(viewModelBlock: @escaping () -> LangPickerViewModel?) {
        self.viewModelBlock = viewModelBlock
    }

    func update(selectedLang: Lang) {
        guard let oldState = state else { return }
        let newState = LangPickerState(
            lang: selectedLang,
            langType: oldState.langType
        )

        state = newState
        listener?.onLangPickerStateChanged(newState)
    }
}
