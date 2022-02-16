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
            viewModel?.update(initState)
            self.state = initState
        }
    }

    private var state: NewWordModelState?

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
        guard let state = state else { return }
        let wordItem = WordItem(text: state.text.trimmingCharacters(in: .whitespacesAndNewlines),
                                sourceLang: state.sourceLang,
                                targetLang: state.targetLang)

        guard !wordItem.text.isEmpty else { return }

        newWordItemStream?.sendNewWord(wordItem)
    }

    /// Обновить написание слова в модели
    /// - Parameters:
    ///  - text: написание слова
    func update(text: String) {
        state?.text = text
        updateViewModel()
    }

    /// Обновить данные об исходном / целевом языке для слова в модели
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
        state?.isLangPickerHidden = true
        updateViewModel()
    }

    /// Показать представление для выбора языка.
    /// - Parameters:
    ///  - selectedLangType: тип выбранного языка (исходный / целевой).
    func showLangPicker(selectedLangType: SelectedLangType) {
        state?.selectedLangType = selectedLangType
        state?.isLangPickerHidden = false
        updateViewModel()
    }

    private func updateViewModel() {
        guard let state = state else { return }

        viewModel?.update(state)
    }
}
