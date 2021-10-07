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
    private let notificationCenter: NotificationCenter

    init(_ langRepository: LangRepository, _ notificationCenter: NotificationCenter) {
        self.langRepository = langRepository
        self.notificationCenter = notificationCenter
    }

    func fetchData() {
        viewModel?.allLangs = langRepository.allLangs
        viewModel?.sourceLang = langRepository.sourceLang
        viewModel?.targetLang = langRepository.targetLang
    }

    func save(sourceLang: Lang) {
        langRepository.sourceLang = sourceLang
    }

    func save(targetLang: Lang) {
        langRepository.targetLang = targetLang
    }

    func sendNewWordEvent(_ newWordText: String) {
        guard !newWordText.isEmpty,
              let sourceLang = viewModel?.sourceLang,
              let targetLang = viewModel?.targetLang else {
            return
        }
        let newWordItem = WordItem(text: newWordText, sourceLang: sourceLang, targetLang: targetLang)

        notificationCenter.post(name: .addNewWord, object: nil, userInfo: [Notification.Name.addNewWord: newWordItem])
    }
}
