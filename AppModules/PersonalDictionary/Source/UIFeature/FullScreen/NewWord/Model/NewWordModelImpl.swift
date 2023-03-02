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

    /// Инициализатор.
    /// - Parameters:
    ///  - viewModelBlock: замыкание для инициализации ссылки на модель представления.
    ///  - langRepository: хранилище с данными о языках в приложении.
    ///  - newWordStream: поток для отправки событий добавления нового слова в словарь
    init(
        langRepository: LangRepository,
        newWordStream: NewWordStream,
        logger: SLogger
    ) {
        self.langRepository = langRepository
        self.newWordStream = newWordStream
        self.logger = logger
    }

    /// Отправить событие добавления нового слова в словарь
    func sendNewWord(_ word: Word) {
        logger.log("NewWord model is sending a word to the new word stream:\n word = \(word)\n")
        newWordStream.sendNewWord(word)
    }

    /// Сохранить исходный язык.
    func save(sourceLang: Lang) {
        langRepository.sourceLang = sourceLang
        logger.log("Source language: \(sourceLang) has been saved.")
    }

    /// Сохранить целевой язык.
    func save(targetLang: Lang) {
        langRepository.targetLang = targetLang
        logger.log("Target language: \(targetLang) has been saved.")
    }
}
