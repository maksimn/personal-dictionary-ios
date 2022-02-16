//
//  NewWordModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

/// Реализация модели "Добавления нового слова" в личный словарь.
final class NewWordModelImpl: NewWordModel {

    /// View model "Добавления нового слова" в личный словарь.
    weak var viewModel: NewWordViewModel? {
        didSet {
            let initState = NewWordModelState(
                text: "",
                sourceLang: langRepository.sourceLang,
                targetLang: langRepository.targetLang,
                selectedLangType: .source,
                isLangPickerHidden: true
            )
            viewModel?.state.accept(initState)
        }
    }

    private var langRepository: LangRepository
    private weak var newWordItemStream: NewWordItemStream?

    /// Инициализатор.
    /// - Parameters:
    ///  - langRepository: хранилище с данными о языках в приложении.
    ///  - newWordItemStream: поток для отправки событий добавления нового слова в словарь
    init(_ langRepository: LangRepository, _ newWordItemStream: NewWordItemStream) {
        self.langRepository = langRepository
        self.newWordItemStream = newWordItemStream
    }

    /// Отправить событие добавления нового слова в словарь
    func sendNewWord() {
        guard let state = viewModel?.state.value else { return }
        let wordItem = WordItem(text: state.text.trimmingCharacters(in: .whitespacesAndNewlines),
                                sourceLang: state.sourceLang,
                                targetLang: state.targetLang)

        guard !wordItem.text.isEmpty else { return }

        newWordItemStream?.sendNewWord(wordItem)
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
