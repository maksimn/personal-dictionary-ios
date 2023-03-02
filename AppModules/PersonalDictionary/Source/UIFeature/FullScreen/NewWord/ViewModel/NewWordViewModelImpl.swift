//
//  NewWordViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

/// Реализация модели представления для экрана добавления нового слова в личный словарь.
final class NewWordViewModelImpl: NewWordViewModel {

    private let model: NewWordModel

    /// Данные модели представления
    let state: BindableNewWordState

    /// Инициализатор.
    /// - Parameters:
    ///  - model: модель фичи "Добавление нового слова"
    init(model: NewWordModel,
         initState: NewWordState) {
        self.model = model
        state = BindableNewWordState(value: initState)
    }

    /// Отправить событие добавления нового слова в словарь
    func sendNewWord() {
        let state = state.value
        let word = Word(
            text: state.text.trimmingCharacters(in: .whitespacesAndNewlines),
            sourceLang: state.sourceLang,
            targetLang: state.targetLang
        )

        guard !word.text.isEmpty else { return }

        model.sendNewWord(word)
    }

    /// Обновить написание слова в модели
    /// - Parameters:
    ///  - text: написание слова
    func update(text: String) {
        var state = state.value

        state.text = text
        self.state.accept(state)
    }

    /// Обновить данные об исходном / целевом языке для слова в модели
    func updateStateWith(langPickerState: LangPickerState) {
        var state = state.value
        
        if langPickerState.langType == .source {
            state.sourceLang = langPickerState.lang
            model.save(sourceLang: langPickerState.lang)
        } else {
            state.targetLang = langPickerState.lang
            model.save(targetLang: langPickerState.lang)
        }

        state.langPickerState = langPickerState

        self.state.accept(state)
    }

    /// Показать представление для выбора языка.
    /// - Parameters:
    ///  - langType: тип выбранного языка (исходный / целевой).
    func presentLangPicker(langType: LangType) {
        var state = state.value
        let langPickerState = LangPickerState(
            lang: langType == .source ? state.sourceLang : state.targetLang,
            langType: langType,
            isHidden: false
        )

        state.langPickerState = langPickerState

        self.state.accept(state)
    }
}
