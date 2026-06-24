//
//  WordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

/// An implementation of a word list model.
struct WordListModelImpl: WordListModel {

    let updateWordDbWorker: UpdateWordDbWorker
    let deleteWordDbWorker: DeleteWordDbWorker
    let updatedWordSender: UpdatedWordSender
    let removedWordSender: RemovedWordSender

    func remove(at position: Int, state: WordListState) async throws -> WordListState {
        return try await remove(at: position, state: state, withSideEffect: true)
    }

    func remove(word: Word, state: WordListState) async throws -> WordListState {
        guard let position = state.firstIndex(where: { $0.id == word.id }) else { return state }

        return try await remove(at: position, state: state, withSideEffect: false)
    }

    private func remove(at position: Int, state: WordListState, withSideEffect: Bool) async throws -> WordListState {
        guard let word = state[safeIndex: position] else { return state }
        var state = state

        state.remove(at: position)

        guard withSideEffect else { return state }

        _ = try await deleteWordDbWorker.delete(word: word)

        removedWordSender.sendRemovedWord(word)

        return state
    }

    func toggleIsFavorite(at position: Int, state: WordListState) async throws -> WordListState {
        guard let wordOldValue = state[safeIndex: position] else { return state }
        var word = wordOldValue
        var state = state

        word.isFavorite.toggle()
        state[position] = word

        _ = try await updateWordDbWorker.update(word: word)

        updatedWordSender.sendUpdatedWord(UpdatedWord(newValue: word, oldValue: wordOldValue))

        return state
    }

    func update(word: UpdatedWord, state: WordListState) async throws -> WordListState {
        guard let position = state.firstIndex(where: { $0.id == word.newValue.id }) else { return state }
        var state = state

        state[position] = word.newValue

        return state
    }
}
