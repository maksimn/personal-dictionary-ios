//
//  WordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxSwift

/// Реализация модели списка слов.
final class WordListModelImpl: WordListModel {

    private let cudOperations: WordCUDOperations
    private let wordSender: RemovedWordSender & UpdatedWordSender
    private let translationService: TranslationService
    private let intervalMs: Int

    init(cudOperations: WordCUDOperations,
         wordSender: RemovedWordSender & UpdatedWordSender,
         translationService: TranslationService,
         intervalMs: Int = 500) {
        self.cudOperations = cudOperations
        self.wordSender = wordSender
        self.translationService = translationService
        self.intervalMs = intervalMs
    }

    func remove(at position: Int, state: WordListState) -> WordListState {
        guard position > -1 && position < state.count else { return state }
        var state = state

        state.remove(at: position)

        return state
    }

    func removeEffect(_ word: Word, state: WordListState) -> Single<WordListState> {
        cudOperations.remove(word)
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
        cudOperations.update(word)
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

        for position in start..<end where state[position].translation == nil {
            notTranslated.append(state[position])
        }

        if notTranslated.isEmpty {
            return Single.just(state)
        }

        var state = state

        return Observable.from(notTranslated)
            .throttle(.milliseconds(intervalMs), scheduler: MainScheduler.instance)
            .flatMap { word in
                self.translationService.fetchTranslation(for: word)
            }
            .flatMap { (translatedWord: Word) in
                self.cudOperations.update(translatedWord)
            }
            .map { (translatedWord: Word) in
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
