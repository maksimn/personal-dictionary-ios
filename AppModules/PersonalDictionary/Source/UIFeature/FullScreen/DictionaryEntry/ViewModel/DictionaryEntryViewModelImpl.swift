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
            state.accept(.loaded(try model.load()))
        } catch {
            state.accept(.error(error.withError()))
        }
    }

    func retryDictionaryEntryRequest() {
        if case .error(let withError) = state.value,
           case DictionaryEntryError.emptyDictionaryEntry(let word) = withError.base {
            let errorState = state.value

            state.accept(.loading)
            model.getDictionaryEntry(for: word)
                .executeInBackgroundAndObserveOnMainThread()
                .subscribe(
                    onSuccess: { [weak self] word in
                        self?.state.accept(.loaded(word))
                    },
                    onFailure: { [weak self] _ in
                        self?.state.accept(errorState)
                   }
                )
                .disposed(by: disposeBag)
        }
    }
}
