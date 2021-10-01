//
//  NewWordModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

class NewWordModelImpl: NewWordModel {

    weak var viewModel: NewWordViewModel?

    private var langRepository: LangRepository

    init(_ langRepository: LangRepository) {
        self.langRepository = langRepository
    }

    func bindData() {
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
}
