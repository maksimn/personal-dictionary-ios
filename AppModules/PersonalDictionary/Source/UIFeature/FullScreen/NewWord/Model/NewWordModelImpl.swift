//
//  NewWordModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

/// Реализация модели "Добавления нового слова" в личный словарь.
final class NewWordModelImpl: NewWordModel {

    private let viewModelBlock: () -> NewWordViewModel?
    private weak var viewModel: NewWordViewModel?
    private var langRepository: LangRepository
    private let newWordStream: NewWordStream

    /// Инициализатор.
    /// - Parameters:
    ///  - viewModelBlock: замыкание для инициализации ссылки на модель представления.
    ///  - langRepository: хранилище с данными о языках в приложении.
    ///  - newWordStream: поток для отправки событий добавления нового слова в словарь
    init(viewModelBlock: @escaping () -> NewWordViewModel?,
         langRepository: LangRepository,
         newWordStream: NewWordStream) {
        self.viewModelBlock = viewModelBlock
        self.langRepository = langRepository
        self.newWordStream = newWordStream
    }

    /// Отправить событие добавления нового слова в словарь
    func sendNewWord() {
        if viewModel == nil {
            viewModel = viewModelBlock()
        }

        guard let state = viewModel?.state.value else { return }
        let word = Word(
            text: state.text.trimmingCharacters(in: .whitespacesAndNewlines),
            sourceLang: state.sourceLang,
            targetLang: state.targetLang
        )

        guard !word.text.isEmpty else { return }

        newWordStream.sendNewWord(word)
    }

    /// Сохранить исходный язык.
    func save(sourceLang: Lang) {
        langRepository.sourceLang = sourceLang
    }

    /// Сохранить целевой язык.
    func save(targetLang: Lang) {
        langRepository.targetLang = targetLang
    }
}
