//
//  MainWordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.03.2023.
//

import RxSwift

final class MainWordListModelImpl: MainWordListModel {

    private let wordListFetcher: WordListFetcher
    private let wordCUDOperations: WordCUDOperations
    private let translationService: TranslationService

    private let newWordIndex = 0

    init(
        wordListFetcher: WordListFetcher,
        wordCUDOperations: WordCUDOperations,
        translationService: TranslationService
    ) {
        self.wordListFetcher = wordListFetcher
        self.wordCUDOperations = wordCUDOperations
        self.translationService = translationService
    }

    func fetchMainWordList() -> WordListState {
        do {
            return try wordListFetcher.wordList()
        } catch {
            return []
        }
    }

    func create(_ word: Word, state: WordListState) -> WordListState {
        var state = state

        state.insert(word, at: newWordIndex)

        return state
    }

    func createEffect(_ word: Word, state: WordListState) -> Single<WordListState> {
        wordCUDOperations.add(word)
            .flatMap { word in
                self.translationService.fetchTranslation(for: word)
            }
            .flatMap { translatedWord in
                self.wordCUDOperations.update(translatedWord)
            }
            .map { translatedWord in
                var state = state

                state[self.newWordIndex] = translatedWord

                return state
            }
    }
}
