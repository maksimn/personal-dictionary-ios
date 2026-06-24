//
//  MainWordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.03.2023.
//

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

    func createEffect(_ word: Word, state: WordListState) async throws -> WordListState {
        let createdWord = try await сreateWordDbWorker.create(word: word)
        let wordData = try await dictionaryService.fetchDictionaryEntry(for: createdWord)
        var state = state
        let updatedWord = wordData.word

        guard let position = state.firstIndex(where: { $0.id == updatedWord.id }) else { return state }

        state[position] = updatedWord

        return state
    }
}
