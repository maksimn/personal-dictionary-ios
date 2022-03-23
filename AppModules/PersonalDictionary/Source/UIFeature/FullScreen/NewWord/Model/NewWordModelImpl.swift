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
    private let newWordItemStream: NewWordItemStream

    /// Инициализатор.
    /// - Parameters:
    ///  - viewModelBlock: замыкание для инициализации ссылки на модель представления.
    ///  - langRepository: хранилище с данными о языках в приложении.
    ///  - newWordItemStream: поток для отправки событий добавления нового слова в словарь
    init(viewModelBlock: @escaping () -> NewWordViewModel?,
         langRepository: LangRepository,
         newWordItemStream: NewWordItemStream) {
        self.viewModelBlock = viewModelBlock
        self.langRepository = langRepository
        self.newWordItemStream = newWordItemStream
    }

    /// Отправить событие добавления нового слова в словарь
    func sendNewWord() {
        if viewModel == nil {
            viewModel = viewModelBlock()
        }

        guard let state = viewModel?.state.value else { return }
        let wordItem = WordItem(text: state.text.trimmingCharacters(in: .whitespacesAndNewlines),
                                sourceLang: state.sourceLang,
                                targetLang: state.targetLang)

        guard !wordItem.text.isEmpty else { return }

        newWordItemStream.sendNewWord(wordItem)
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
