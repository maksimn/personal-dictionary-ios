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

    private(set) var allLangs: [Lang] = [] {
        didSet {
            viewModel?.allLangs = allLangs
        }
    }

    private static let empty = Lang(id: Lang.Id(raw: -1), name: "", shortName: "")

    init(_ langRepository: LangRepository, _ notificationCenter: NotificationCenter) {
        self.langRepository = langRepository
        self.notificationCenter = notificationCenter
        notificationCenter.addObserver(self, selector: #selector(onLangSelected), name: .langSelected, object: nil)
    }

    func fetchData() {
        allLangs = langRepository.allLangs
        sourceLang = langRepository.sourceLang
        targetLang = langRepository.targetLang
    }

    func sendNewWord() {
        guard let text = viewModel?.text.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else {
            return
        }
        let wordItem = WordItem(text: text, sourceLang: sourceLang, targetLang: targetLang)

        notificationCenter.post(name: .addNewWord, object: nil, userInfo: [Notification.Name.addNewWord: wordItem])
    }

    @objc
    func onLangSelected(_ notification: Notification) {
        if let langSelectorData = notification.userInfo?[Notification.Name.langSelected] as? LangSelectorData {
            if langSelectorData.isSourceLang {
                langRepository.sourceLang = langSelectorData.lang
                sourceLang = langSelectorData.lang
            } else {
                langRepository.targetLang = langSelectorData.lang
                targetLang = langSelectorData.lang
            }
            viewModel?.dismissLangPicker()
        }
    }
}
