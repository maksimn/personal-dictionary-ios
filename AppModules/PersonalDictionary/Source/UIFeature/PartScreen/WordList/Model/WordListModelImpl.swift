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
    private let dictionaryService: DictionaryService
    private let intervalMs: Int

    init(updateWordDbWorker: UpdateWordDbWorker,
         deleteWordDbWorker: DeleteWordDbWorker,
         wordSender: RemovedWordSender & UpdatedWordSender,
         dictionaryService: DictionaryService,
         intervalMs: Int = 500) {
        self.updateWordDbWorker = updateWordDbWorker
        self.deleteWordDbWorker = deleteWordDbWorker
        self.wordSender = wordSender
        self.dictionaryService = dictionaryService
        self.intervalMs = intervalMs
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

    func updateEffect(_ word: Word, state: WordListState) -> Single<WordListState> {
        updateWordDbWorker.update(word: word)
            .do(onSuccess: { word in
                self.wordSender.sendUpdatedWord(word)
            })
            .map { _ in
                state
            }
    }

    func fetchTranslationsFor(state: WordListState, start: Int, end: Int) -> Single<WordListState> {
        guard state.count > 0 else {
            return Single.just([])
        }

        let end = min(state.count, end)
        guard end > start, start > -1 else { return .error(WordListError.wrongIndices) }
        var notTranslated: WordListState = []

        for position in start..<end where state[position].dictionaryEntry.isEmpty {
            notTranslated.append(state[position])
        }

        if notTranslated.isEmpty {
            return Single.just(state)
        }

        var state = state

        return Observable.from(notTranslated)
            .throttle(.milliseconds(intervalMs), scheduler: MainScheduler.instance)
            .flatMap { word in
                self.dictionaryService.fetchDictionaryEntry(for: word)
            }
            .flatMap { translatedWord in
                self.updateWordDbWorker.update(word: translatedWord)
            }
            .map { translatedWord in
                for i in start..<end where state[i].id == translatedWord.id {
                    state[i] = translatedWord
                }
                return state
            }
            .takeLast(1)
            .asSingle()
    }

    enum WordListError: Error { case wrongIndices }
}
