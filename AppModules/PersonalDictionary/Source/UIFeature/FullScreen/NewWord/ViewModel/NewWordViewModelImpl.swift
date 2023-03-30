//
//  NewWordViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import CoreModule

/// Реализация модели представления для экрана добавления нового слова в личный словарь.
final class NewWordViewModelImpl: NewWordViewModel {

    let state: BindableNewWordState

    private let model: NewWordModel
    private let logger: Logger

    /// - Parameters:
    ///  - model: модель фичи "Добавление нового слова"
    init(model: NewWordModel, initState: NewWordState, logger: Logger) {
        self.model = model
        self.logger = logger
        state = BindableNewWordState(value: initState)
    }

    func update(text: String) {
        var state = state.value

        state.text = text
        onNewState(state, actionName: "UDPATE TEXT")
    }

    func onLangPickerStateChanged(_ langPickerState: LangPickerState) {
        let state = model.selectLangEffect(langPickerState, state: self.state.value)

        onNewState(state, actionName: "SELECT LANGUAGE")
    }

    func presentLangPicker(langType: LangType) {
        let state = model.presentLangPicker(langType: langType, state: state.value)

        onNewState(state, actionName: "PRESENT LANGPICKER")
    }

    func sendNewWord() {
        model.sendNewWord(state.value)
    }

    private func onNewState(_ state: NewWordState, actionName: String) {
        logger.logState(actionName: actionName, state)

        self.state.accept(state)
    }
}
