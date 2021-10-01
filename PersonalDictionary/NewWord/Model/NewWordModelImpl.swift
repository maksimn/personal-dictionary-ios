//
//  NewWordModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

class NewWordModelImpl: NewWordModel {

    var viewModel: NewWordViewModel?

    private let langRepository: LangRepository

    init(_ langRepository: LangRepository) {
        self.langRepository = langRepository
    }

    func bindData() {
        viewModel?.allLangs = langRepository.allLangs
        viewModel?.sourceLang = langRepository.sourceLang
        viewModel?.targetLang = langRepository.targetLang
    }

    func save(_ sourceLang: Lang, _ targetLang: Lang) {
        
    }
}
