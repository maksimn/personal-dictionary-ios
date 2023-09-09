//
//  MainWordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.03.2023.
//

import RxSwift

struct MainWordListModelImpl: MainWordListModel {

    let wordListFetcher: WordListFetcher
    let сreateWordDbWorker: CreateWordDbWorker
    let dictionaryService: DictionaryService

    func fetchMainWordList() -> WordListState {
        do {
            return try wordListFetcher.wordList()
        } catch {
            return []
        }
    }

    func create(_ word: Word, state: WordListState) -> WordListState {
        var state = state

        state.insert(word, at: 0)

        return state
    }

    func createEffect(_ word: Word, state: WordListState) -> Single<WordListState> {
        сreateWordDbWorker.create(word: word)
            .flatMap { word in
                self.dictionaryService.fetchDictionaryEntry(for: word)
            }
            .map { wordData in
                var state = state
                let word = wordData.word

                guard let position = state.firstIndex(where: { $0.id == word.id }) else { return state }

                state[position] = wordData.word

                return state
            }
    }
}
