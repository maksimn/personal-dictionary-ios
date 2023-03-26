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
    private let logger: Logger

    /// - Parameters:
    ///  - viewModelBlock: замыкание для инициализации ссылки на модель представления.
    ///  - langRepository: хранилище с данными о языках в приложении.
    ///  - newWordStream: поток для отправки событий добавления нового слова в словарь
    init(langRepository: LangRepository, newWordStream: NewWordStream, logger: Logger) {
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

        logger.logSending(word, toModelStream: "NEW WORD")
        newWordStream.sendNewWord(word)
    }

    // MARK: - Private

    private func save(sourceLang: Lang) {
        langRepository.sourceLang = sourceLang
        logger.logContext(saveLangMessage(.source, lang: sourceLang))
    }

    private func save(targetLang: Lang) {
        langRepository.targetLang = targetLang
        logger.logContext(saveLangMessage(.target, lang: targetLang))
    }

    private func saveLangMessage(_ langType: LangType, lang: Lang) -> String {
        "\(langType) language: \(lang) has been saved."
    }
}
