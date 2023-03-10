//
//  NewWordViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

/// Реализация модели представления для экрана добавления нового слова в личный словарь.
final class NewWordViewModelImpl: NewWordViewModel {

    let state: BindableNewWordState

    private let model: NewWordModel

    /// - Parameters:
    ///  - model: модель фичи "Добавление нового слова"
    init(model: NewWordModel, initState: NewWordState) {
        self.model = model
        state = BindableNewWordState(value: initState)
    }

    func update(text: String) {
        var state = state.value

        state.text = text
        self.state.accept(state)
    }

    func updateStateWith(langPickerState: LangPickerState) {
        let state = model.selectLangEffect(langPickerState, state: state.value)

        self.state.accept(state)
    }

    func presentLangPicker(langType: LangType) {
        let state = model.presentLangPicker(langType: langType, state: state.value)

        self.state.accept(state)
    }

    func sendNewWord() {
        model.sendNewWord(state.value)
    }
}
