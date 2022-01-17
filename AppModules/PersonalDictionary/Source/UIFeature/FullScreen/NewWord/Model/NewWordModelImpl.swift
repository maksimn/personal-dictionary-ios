//
//  NewWordModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import Foundation

/// Реализация модели "Добавления нового слова" в личный словарь.
final class NewWordModelImpl: NewWordModel {

    /// View model "Добавления нового слова" в личный словарь.
    weak var viewModel: NewWordViewModel?

    private var langRepository: LangRepository
    private weak var newWordItemStream: NewWordItemStream?

    private var state: NewWordModelState? {
        didSet {
            viewModel?.state = state
        }
    }

    /// Инициализатор.
    /// - Parameters:
    ///  - langRepository: хранилище с данными о языках в приложении.
    ///  - newWordItemStream: поток для отправки событий добавления нового слова в словарь
    init(_ langRepository: LangRepository, _ newWordItemStream: NewWordItemStream) {
        self.langRepository = langRepository
        self.newWordItemStream = newWordItemStream
    }

    /// Связать начальное состояние модели с представлением
    func bindInitially() {
        state = NewWordModelState(text: "",
                                  sourceLang: langRepository.sourceLang,
                                  targetLang: langRepository.targetLang)
    }

    /// Отправить событие добавления нового слова в словарь
    func sendNewWord() {
        guard let text = state?.text.trimmingCharacters(in: .whitespacesAndNewlines),
            !text.isEmpty,
            let sourceLang = state?.sourceLang,
            let targetLang = state?.targetLang else {
            return
        }

        let wordItem = WordItem(text: text, sourceLang: sourceLang, targetLang: targetLang)

        newWordItemStream?.sendNewWord(wordItem)
    }

    /// Обновить написание слова
    /// - Parameters:
    ///  - text: написание слова
    func update(text: String) {
        state?.text = text
    }

    /// Обновить данные об исходном / целевом языке для слова
    /// - Parameters:
    ///  - data: данные о выбранном языке.
    func update(data: LangSelectorData) {
        if data.selectedLangType == .source {
            state?.sourceLang = data.selectedLang
            langRepository.sourceLang = data.selectedLang
        } else {
            state?.targetLang = data.selectedLang
            langRepository.targetLang = data.selectedLang
        }
    }
}
