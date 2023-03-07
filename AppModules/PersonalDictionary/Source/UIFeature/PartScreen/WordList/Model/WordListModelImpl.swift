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
    private let wordStream: RemovedWordStream & UpdatedWordStream
    private let translationService: TranslationService
    private let intervalMs: Int

    init(cudOperations: WordCUDOperations,
         wordStream: RemovedWordStream & UpdatedWordStream,
         translationService: TranslationService,
         intervalMs: Int = 500) {
        self.cudOperations = cudOperations
        self.wordStream = wordStream
        self.translationService = translationService
        self.intervalMs = intervalMs
    }

    func create(_ word: Word) -> Completable {
        cudOperations.add(word)
            .flatMap { word in
                self.translationService.fetchTranslation(for: word)
            }
            .flatMap { translatedWord in
                self.updateSingle(translatedWord)
            }
            .asCompletable()
    }

    func remove(_ word: Word) -> Completable {
        cudOperations.remove(word)
            .map { word in
                self.wordStream.sendRemovedWord(word)
            }
            .asCompletable()
    }

    func update(_ word: Word) -> Completable {
        updateSingle(word).asCompletable()
    }

    func fetchTranslationsFor(_ wordList: [Word], start: Int, end: Int) -> Completable {
        guard end > start, start > -1 else { return .empty() }
        let end = min(wordList.count, end)
        var notTranslated: [Word] = []

        for position in start..<end where wordList[position].translation == nil {
            notTranslated.append(wordList[position])
        }

        return Observable.from(notTranslated)
            .throttle(.milliseconds(intervalMs), scheduler: MainScheduler.instance)
            .flatMap { word in
                self.translationService.fetchTranslation(for: word)
            }
            .flatMap { translatedWord in
                self.update(translatedWord)
            }
            .asCompletable()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
    }

    private func updateSingle(_ word: Word) -> Single<Word> {
        cudOperations.update(word)
            .map { word in
                self.wordStream.sendUpdatedWord(word)
                return word
            }
    }
}
