//
//  DictionaryEntryViewModel.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import Observation

@Observable
final class DictionaryEntryViewModelImpl: DictionaryEntryViewModel {

    var state: DictionaryEntryState = .initial

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
            state = .loaded(try model.load())
        } catch {
            state = .error(error.withError())
        }
    }

    func retryDictionaryEntryRequest() {
        if case .error(let withError) = state,
           case DictionaryEntryError.emptyDictionaryEntry(let word) = withError.base {
            let errorState = state

            state = .loading
            tasks.append(
                Task { [weak self] in
                    guard let self else { return }

                    do {
                        let word = try await self.model.getDictionaryEntry(for: word)

                        state = .loaded(word)
                    } catch {
                        state = errorState
                    }
                }
            )
        }
    }
}
