//
//  WordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import CoreModule
import RxSwift

/// Реализация модели списка слов.
final class WordListModelImpl: WordListModel {

    private let viewModelBlock: () -> WordListViewModel?
    private weak var viewModel: WordListViewModel?

    private let cudOperations: WordItemCUDOperations
    private let wordItemStream: WordItemStream
    private let translationService: TranslationService

    private let disposeBag = DisposeBag()

    /// Стейт модели списка слов.
    var wordList: [WordItem] = [] {
        didSet {
            if viewModel == nil {
                viewModel = viewModelBlock()
            }
            viewModel?.wordList.accept(wordList)
        }
    }

    /// Инициализатор.
    /// - Parameters:
    ///  - viewModelBlock: замыкание для инициализации ссылки на модель представления.
    ///  - cudOperations: сервис для операций create, update, delete со словами в хранилище личного словаря.
    ///  - translationService: cлужба для выполнения перевода слов на целевой язык.
    ///  - wordItemStream: ModelStream для событий со словами в личном словаре.
    init(viewModelBlock: @escaping () -> WordListViewModel?,
         cudOperations: WordItemCUDOperations,
         translationService: TranslationService,
         wordItemStream: WordItemStream) {
        self.viewModelBlock = viewModelBlock
        self.cudOperations = cudOperations
        self.translationService = translationService
        self.wordItemStream = wordItemStream
        subscribeToWordItemStream()
    }

    /// Удалить слово по заданному индексу из списка
    /// - Parameters:
    ///  - position: позиция (индекс) слова в списке.
    func remove(at position: Int) {
        let removedWordItem = removeInMemory(at: position)

        cudOperations.remove(with: removedWordItem.id).subscribe().disposed(by: disposeBag)
        wordItemStream.sendRemovedWordItem(removedWordItem)
    }

    /// Переключить значение флага "избранности" (isFavorite) для слова по заданному индексу из списка
    /// - Parameters:
    ///  - position: позиция (индекс) слова в списке.
    func toggleWordItemIsFavorite(at position: Int) {
        let updatedWordItem = toggleWordItemIsFavoriteInMemory(at: position)

        cudOperations.update(updatedWordItem).subscribe().disposed(by: disposeBag)
        wordItemStream.sendUpdatedWordItem(updatedWordItem)
    }

    /// Запросить перевод для слов в списке, расположенных в заданном интервале индексов.
    /// - Parameters:
    ///  - startPosition: позиция (индекс) начального слова.
    ///  - endPosition: верхняя граница индексов слов для перевода (не включая).
    func requestTranslationsIfNeededWithin(startPosition: Int, endPosition: Int) {
        guard endPosition > startPosition, startPosition > -1 else { return }
        let endPosition = min(wordList.count, endPosition)
        var notTranslatedItems = [(word: WordItem, position: Int)]()

        for position in startPosition..<endPosition where wordList[position].translation == nil {
            notTranslatedItems.append((word: wordList[position], position: position))
        }

        guard notTranslatedItems.count > 0 else { return }

        Observable.from(notTranslatedItems)
            .concatMap { tuple in
                Single.just(tuple).delay(.milliseconds(500), scheduler: MainScheduler.instance)
            }
            .do(onNext: { [weak self] tuple in
                self?.requestTranslation(for: tuple.word, tuple.position)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }

    // MARK: - Private

    private func removeInMemory(at position: Int) -> WordItem {
        let wordItem = wordList[position]

        wordList.remove(at: position)

        return wordItem
    }

    private func toggleWordItemIsFavoriteInMemory(at position: Int) -> WordItem {
        var wordItem = wordList[position]

        wordItem.isFavorite = !wordItem.isFavorite
        wordList[position] = wordItem

        return wordItem
    }

    private func addNewWord(_ wordItem: WordItem) {
        let newWordPosition = 0

        wordList.insert(wordItem, at: newWordPosition)
        cudOperations.add(wordItem)
            .subscribe()
            .disposed(by: disposeBag)
        requestTranslation(for: wordItem, newWordPosition)
    }

    private func remove(wordItem: WordItem) {
        if let position = wordList.firstIndex(where: { $0.id == wordItem.id }) {
            _ = removeInMemory(at: position)
        }
    }

    private func requestTranslation(for wordItem: WordItem, _ position: Int) {
        translationService.fetchTranslation(for: wordItem)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] translation in
                self?.update(wordItem: wordItem, with: translation, at: position)
            }, onError: { _ in

            }).disposed(by: disposeBag)
    }

    private func update(wordItem: WordItem, with translation: String, at position: Int) {
        var updatedWordItem = wordItem

        updatedWordItem.translation = translation

        guard position > -1 && position < wordList.count else { return }

        wordList[position] = updatedWordItem
        cudOperations.update(updatedWordItem)
            .subscribe()
            .disposed(by: disposeBag)
    }

    private func updateInMemory(updatedWordItem: WordItem) {
        if let position = wordList.firstIndex(where: { $0.id == updatedWordItem.id }) {
            wordList[position] = updatedWordItem
        }
    }

    private func subscribeToWordItemStream() {
        wordItemStream.newWordItem
            .subscribe(onNext: { [weak self] in self?.addNewWord($0) })
            .disposed(by: disposeBag)
        wordItemStream.removedWordItem
            .subscribe(onNext: { [weak self] in self?.remove(wordItem: $0) })
            .disposed(by: disposeBag)
        wordItemStream.updatedWordItem
            .subscribe(onNext: { [weak self] in self?.updateInMemory(updatedWordItem: $0) })
            .disposed(by: disposeBag)
    }
}
