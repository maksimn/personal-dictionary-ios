//
//  LangPickerModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

/// Реализация модели выбора языка.
final class LangPickerModelImpl: LangPickerModel {

    weak var listener: LangPickerListener?

    private let viewModelBlock: () -> LangPickerViewModel?
    private weak var viewModel: LangPickerViewModel?

    init(viewModelBlock: @escaping () -> LangPickerViewModel?) {
        self.viewModelBlock = viewModelBlock
    }

    func set(state: LangPickerState) {
        if viewModel == nil {
            viewModel = viewModelBlock()
        }

        viewModel?.state.accept(state)
    }
}
