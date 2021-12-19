//
//  NewWordModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import Foundation

class NewWordModelImpl: NewWordModel {

    weak var viewModel: NewWordViewModel?

    private var langRepository: LangRepository
    private weak var wordItemStream: NewWordItemStream?

    private(set) var state: NewWordModelState? {
        didSet {
            viewModel?.state = state
        }
    }

    init(_ langRepository: LangRepository, _ wordItemStream: NewWordItemStream) {
        self.langRepository = langRepository
        self.wordItemStream = wordItemStream
    }

    func bindInitially() {
        state = NewWordModelState(text: "",
                                  sourceLang: langRepository.sourceLang,
                                  targetLang: langRepository.targetLang)
    }

    func sendNewWord() {
        guard let text = state?.text.trimmingCharacters(in: .whitespacesAndNewlines),
            !text.isEmpty,
            let sourceLang = state?.sourceLang,
            let targetLang = state?.targetLang else {
            return
        }

        let wordItem = WordItem(text: text, sourceLang: sourceLang, targetLang: targetLang)

        wordItemStream?.sendNewWord(wordItem)
    }

    func update(text: String) {
        state?.text = text
    }

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
