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
    private weak var listener: NewWordListener?

    private(set) var sourceLang: Lang = empty {
        didSet {
            viewModel?.sourceLang = sourceLang
        }
    }

    private(set) var targetLang: Lang = empty {
        didSet {
            viewModel?.targetLang = targetLang
        }
    }

    private static let empty = Lang(id: Lang.Id(raw: -1), name: "", shortName: "")

    init(_ langRepository: LangRepository, _ listener: NewWordListener?) {
        self.langRepository = langRepository
        self.listener = listener
    }

    func bindInitially() {
        sourceLang = langRepository.sourceLang
        targetLang = langRepository.targetLang
    }

    func sendNewWord() {
        guard let text = viewModel?.text.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else {
            return
        }
        let wordItem = WordItem(text: text, sourceLang: sourceLang, targetLang: targetLang)

        listener?.onNewWord(wordItem)
    }

    func update(_ langType: SelectedLangType, _ lang: Lang) {
        switch langType {
        case .source:
            langRepository.sourceLang = lang
            sourceLang = lang
        case .target:
            langRepository.targetLang = lang
            targetLang = lang
        }
    }
}
