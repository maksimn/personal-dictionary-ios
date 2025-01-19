//
//  WordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxSwift

/// An implementation of a word list model.
struct WordListModelImpl: WordListModel {

    let updateWordDbWorker: UpdateWordDbWorker
    let deleteWordDbWorker: DeleteWordDbWorker
    let updatedWordSender: UpdatedWordSender
    let removedWordSender: RemovedWordSender

    func remove(at position: Int, state: WordListState) -> Single<WordListState> {
        return remove(at: position, state: state, withSideEffect: true)
    }

    func remove(word: Word, state: WordListState) -> Single<WordListState> {
        guard let position = state.firstIndex(where: { $0.id == word.id }) else { return .just(state) }

        return remove(at: position, state: state, withSideEffect: false)
    }

    private func remove(at position: Int, state: WordListState, withSideEffect: Bool) -> Single<WordListState> {
        guard let word = state[safeIndex: position] else { return .just(state) }
        var state = state

        state.remove(at: position)

        guard withSideEffect else { return .just(state) }

        return deleteWordDbWorker.delete(word: word)
            .do(onSuccess: { word in
                self.removedWordSender.sendRemovedWord(word)
            })
            .map { _ in state }
            .executeInBackgroundAndObserveOnMainThread()
    }

    func toggleIsFavorite(at position: Int, state: WordListState) -> Single<WordListState> {
        guard let wordOldValue = state[safeIndex: position] else { return .just(state) }
        var word = wordOldValue
        var state = state

        word.isFavorite.toggle()
        state[position] = word

        return updateWordDbWorker.update(word: word)
            .do(onSuccess: { _ in
                self.updatedWordSender.sendUpdatedWord(UpdatedWord(newValue: word, oldValue: wordOldValue))
            })
            .map { _ in state }
            .executeInBackgroundAndObserveOnMainThread()
    }

    func update(word: UpdatedWord, state: WordListState) -> Single<WordListState> {
        guard let position = state.firstIndex(where: { $0.id == word.newValue.id }) else { return .just(state) }
        var state = state

        state[position] = word.newValue

        return .just(state)
    }
}
