//
//  WordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxSwift

/// Реализация модели списка слов.
final class WordListModelImpl: WordListModel {

    private let updateWordDbWorker: UpdateWordDbWorker
    private let deleteWordDbWorker: DeleteWordDbWorker
    private let wordSender: RemovedWordSender & UpdatedWordSender

    init(updateWordDbWorker: UpdateWordDbWorker,
         deleteWordDbWorker: DeleteWordDbWorker,
         wordSender: RemovedWordSender & UpdatedWordSender) {
        self.updateWordDbWorker = updateWordDbWorker
        self.deleteWordDbWorker = deleteWordDbWorker
        self.wordSender = wordSender
    }

    func remove(at position: Int, state: WordListState) -> WordListState {
        guard position > -1 && position < state.count else { return state }
        var state = state

        state.remove(at: position)

        return state
    }

    func removeEffect(_ word: Word, state: WordListState) -> Single<WordListState> {
        deleteWordDbWorker.delete(word: word)
            .do(onSuccess: { word in
                self.wordSender.sendRemovedWord(word)
            })
            .map { _ in
                state
            }
    }

    func update(_ word: Word, at position: Int, state: WordListState) -> WordListState {
        guard position > -1 && position < state.count else { return state }
        var state = state

        state[position] = word

        return state
    }

    func updateEffect(_ updatedWord: UpdatedWord, state: WordListState) -> Single<WordListState> {
        updateWordDbWorker.update(word: updatedWord.newValue)
            .do(onSuccess: { _ in
                self.wordSender.sendUpdatedWord(updatedWord)
            })
            .map { _ in
                state
            }
    }
}
