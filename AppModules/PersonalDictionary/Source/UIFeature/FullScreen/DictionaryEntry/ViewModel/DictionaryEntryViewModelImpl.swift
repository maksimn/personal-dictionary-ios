//
//  DictionaryEntryViewModel.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import Combine

final class DictionaryEntryViewModelImpl: DictionaryEntryViewModel {

    let state = BindableDictionaryEntryState(.initial)

    private let model: DictionaryEntryModel

    private var tasks: [Task<Void, Never>] = []

    init(model: DictionaryEntryModel) {
        self.model = model
    }

    deinit {
        tasks.forEach { $0.cancel() }
    }

    func load() {
        do {
            state.send(.loaded(try model.load()))
        } catch {
            state.send(.error(error.withError()))
        }
    }

    func retryDictionaryEntryRequest() {
        if case .error(let withError) = state.value,
           case DictionaryEntryError.emptyDictionaryEntry(let word) = withError.base {
            let errorState = state.value

            state.send(.loading)
            tasks.append(
                Task { [weak self] in
                    guard let self else { return }

                    do {
                        let word = try await self.model.getDictionaryEntry(for: word)

                        state.send(.loaded(word))
                    } catch {
                        state.send(errorState)
                    }
                }
            )
        }
    }
}
