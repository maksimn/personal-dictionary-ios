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

    init(cudOperations: WordCUDOperations,
         wordStream: RemovedWordStream & UpdatedWordStream,
         translationService: TranslationService) {
        self.cudOperations = cudOperations
        self.wordStream = wordStream
        self.translationService = translationService
    }

    func create(_ word: Word) -> Completable {
        cudOperations.add(word)
            .andThen(
                translationService.fetchTranslation(for: word)
                    .map { [weak self] word in
                        self?.wordStream.sendUpdatedWord(word)
                        return word
                    }
                    .asCompletable()
            )
    }

    func remove(_ word: Word) -> Completable {
        cudOperations.remove(with: word.id)
            .andThen(
                Completable.create { [weak self] completable in
                    self?.wordStream.sendRemovedWord(word)

                    return Disposables.create {}
                }
            )
    }

    func update(_ word: Word) -> Completable {
        cudOperations.update(word)
            .andThen(
                Completable.create { [weak self] completable in
                    self?.wordStream.sendUpdatedWord(word)

                    return Disposables.create {}
                }
            )
    }

    func fetchTranslationsFor(_ notTranslated: [Word]) -> Observable<Word> {
        Observable.from(notTranslated)
            .concatMap { word in
                Single.just(word).delay(.milliseconds(500), scheduler: MainScheduler.instance)
            }
            .map { (word: Word) -> Single<Word> in
                self.translationService.fetchTranslation(for: word)
            }
            .concat()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
    }
}
