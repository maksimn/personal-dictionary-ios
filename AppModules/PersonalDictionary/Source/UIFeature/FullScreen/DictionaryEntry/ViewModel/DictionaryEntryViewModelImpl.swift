//
//  DictionaryEntryViewModel.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import RxSwift

final class DictionaryEntryViewModelImpl: DictionaryEntryViewModel {

    let state = BindableDictionaryEntryState(value: .initial)

    private let model: DictionaryEntryModel
    private let disposeBag = DisposeBag()

    init(model: DictionaryEntryModel) {
        self.model = model
    }

    func load() {
        do {
            let word = try model.load()

            if word.dictionaryEntry.isEmpty {
                state.accept(.error(DictionaryEntryError.emptyDictionaryEntry(word)))
            } else {
                state.accept(.loaded(word))
            }
        } catch {
            state.accept(.error(error))
        }
    }

    func retryDictionaryEntryRequest() {
        if case .error(DictionaryEntryError.emptyDictionaryEntry(let word)) = state.value {
            state.accept(.loading)
            model.getDictionaryEntry(for: word)
                .executeInBackgroundAndObserveOnMainThread()
                .subscribe(
                    onSuccess: { [weak self] word in
                        self?.state.accept(.loaded(word))
                    },
                    onFailure: {  [weak self] _ in
                        self?.state.accept(.error(DictionaryEntryError.emptyDictionaryEntry(word)))
                   }
                )
                .disposed(by: disposeBag)
        }
    }
}
