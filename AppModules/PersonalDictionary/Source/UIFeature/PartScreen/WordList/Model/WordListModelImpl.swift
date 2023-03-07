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

    func create(_ word: Word) -> Single<Word> {
        cudOperations.add(word)
            .flatMap { word in
                self.translationService.fetchTranslation(for: word)
            }
            .flatMap { translatedWord in
                self.cudOperations.update(translatedWord)
            }
    }

    func remove(_ word: Word) -> Single<Word> {
        cudOperations.remove(word)
            .map { word in
                self.wordStream.sendRemovedWord(word)
                return word
            }
    }

    func update(_ word: Word) -> Single<Word> {
        cudOperations.update(word)
            .map { word in
                self.wordStream.sendUpdatedWord(word)
                return word
            }
    }

    func fetchTranslationsFor(_ wordList: [Word], start: Int, end: Int) -> Observable<Word> {
        let end = min(wordList.count, end)
        guard end > start, start > -1 else { return .error(WordListError.wrongIndices) }
        var notTranslated: [Word] = []

        for position in start..<end where wordList[position].translation == nil {
            notTranslated.append(wordList[position])
        }

        return Observable.from(notTranslated)
            .throttle(.milliseconds(intervalMs), scheduler: MainScheduler.instance)
            .flatMap { word in
                self.translationService.fetchTranslation(for: word)
            }
            .flatMap { (translatedWord: Word) in
                self.cudOperations.update(translatedWord)
            }
    }

    enum WordListError: Error { case wrongIndices }
}
