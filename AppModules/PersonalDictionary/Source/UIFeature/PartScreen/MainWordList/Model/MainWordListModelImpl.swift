//
//  MainWordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.03.2023.
//

import RxSwift

final class MainWordListModelImpl: MainWordListModel {

    private let wordListFetcher: WordListFetcher
    private let сreateWordDbWorker: CreateWordDbWorker
    private let updateWordDbWorker: UpdateWordDbWorker
    private let dictionaryService: DictionaryService

    private let newWordIndex = 0

    init(
        wordListFetcher: WordListFetcher,
        сreateWordDbWorker: CreateWordDbWorker,
        updateWordDbWorker: UpdateWordDbWorker,
        dictionaryService: DictionaryService
    ) {
        self.wordListFetcher = wordListFetcher
        self.сreateWordDbWorker = сreateWordDbWorker
        self.updateWordDbWorker = updateWordDbWorker
        self.dictionaryService = dictionaryService
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
        сreateWordDbWorker.create(word: word)
            .flatMap { word in
                self.dictionaryService.fetchDictionaryEntry(for: word)
            }
            .flatMap { translatedWord in
                self.updateWordDbWorker.update(word: translatedWord)
            }
            .map { translatedWord in
                var state = state

                state[self.newWordIndex] = translatedWord

                return state
            }
    }
}
