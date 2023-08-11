//
//  DictionaryEntryViewModel.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

struct DictionaryEntryViewModelImpl: DictionaryEntryViewModel {

    let state = BindableDictionaryEntryState(value: .initial)

    private let model: DictionaryEntryModel

    init(model: DictionaryEntryModel) {
        self.model = model
    }

    func load() {
        do {
            let word = try model.load()

            state.accept(.with(word))
        } catch {
            state.accept(.error(error))
        }
    }
}
