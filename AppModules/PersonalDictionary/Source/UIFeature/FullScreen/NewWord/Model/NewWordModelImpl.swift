//
//  NewWordModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import CoreModule

/// Реализация модели "Добавления нового слова" в личный словарь.
final class NewWordModelImpl: NewWordModel {

    private var langRepository: LangRepository
    private let newWordStream: NewWordStream
    private let logger: SLogger

    /// - Parameters:
    ///  - viewModelBlock: замыкание для инициализации ссылки на модель представления.
    ///  - langRepository: хранилище с данными о языках в приложении.
    ///  - newWordStream: поток для отправки событий добавления нового слова в словарь
    init(langRepository: LangRepository, newWordStream: NewWordStream, logger: SLogger) {
        self.langRepository = langRepository
        self.newWordStream = newWordStream
        self.logger = logger
    }

    func selectLangEffect(_ langPickerState: LangPickerState, state: NewWordState) -> NewWordState {
        var state = state

        if langPickerState.langType == .source {
            state.sourceLang = langPickerState.lang
            save(sourceLang: langPickerState.lang)
        } else {
            state.targetLang = langPickerState.lang
            save(targetLang: langPickerState.lang)
        }

        state.langPickerState = langPickerState

        return state
    }

    func presentLangPicker(langType: LangType, state: NewWordState) -> NewWordState {
        var state = state
        let langPickerState = LangPickerState(
            lang: langType == .source ? state.sourceLang : state.targetLang,
            langType: langType,
            isHidden: false
        )

        state.langPickerState = langPickerState

        return state
    }

    /// Отправить событие добавления нового слова в словарь
    func sendNewWord(_ state: NewWordState) {
        let word = Word(
            text: state.text.trimmingCharacters(in: .whitespacesAndNewlines),
            sourceLang: state.sourceLang,
            targetLang: state.targetLang
        )

        guard !word.text.isEmpty else { return }

        logSendNewWord(word)
        newWordStream.sendNewWord(word)
    }

    // MARK: - Private

    private func save(sourceLang: Lang) {
        langRepository.sourceLang = sourceLang
        logSavedLang(.source, lang: sourceLang)
    }

    private func save(targetLang: Lang) {
        langRepository.targetLang = targetLang
        logSavedLang(.target, lang: targetLang)
    }

    // MARK: - Logging

    private func logSendNewWord(_ word: Word) {
        logger.log("NewWord model is sending a word to the new word stream:\n word = \(word)\n")
    }

    private func logSavedLang(_ langType: LangType, lang: Lang) {
        logger.log("\(langType) language: \(lang) has been saved.")
    }
}
