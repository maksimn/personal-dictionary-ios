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
    private lazy var viewModel: WordListViewModel? = viewModelBlock()

    private let cudOperations: WordItemCUDOperations
    private let wordItemStream: ReadableWordItemStream & RemovedWordItemStream
    private let translationService: TranslationService

    private let disposeBag = DisposeBag()

    /// Стейт модели списка слов.
    var data: WordListData = WordListData(wordList: [], changedItemPosition: nil) {
        didSet {
            viewModel?.wordListData = data
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
         wordItemStream: ReadableWordItemStream & RemovedWordItemStream) {
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
        var wordList = data.wordList
        let wordItem = wordList[position]

        wordList.remove(at: position)
        data = WordListData(wordList: wordList, changedItemPosition: position)
        cudOperations.remove(with: wordItem.id)
            .subscribe()
            .disposed(by: disposeBag)
    }

    /// Отправить оповещение об удалении слова.
    /// - Parameters:
    ///  - wordItem: удаленное слово.
    func sendRemovedWordItem(_ wordItem: WordItem) {
        wordItemStream.sendRemovedWordItem(wordItem)
    }

    /// Запросить перевод для слов в списке, расположенных в заданном интервале индексов.
    /// - Parameters:
    ///  - startPosition: позиция (индекс) начального слова.
    ///  - endPosition: верхняя граница индексов слов для перевода (не включая).
    func requestTranslationsIfNeededWithin(startPosition: Int, endPosition: Int) {
        guard endPosition > startPosition, startPosition > -1 else { return }
        let endPosition = min(data.wordList.count, endPosition)
        var notTranslatedItems = [(word: WordItem, position: Int)]()

        for position in startPosition..<endPosition where data.wordList[position].translation == nil {
            notTranslatedItems.append((word: data.wordList[position], position: position))
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

    private func addNewWord(_ wordItem: WordItem) {
        let newWordPosition = 0
        var wordList = data.wordList

        wordList.insert(wordItem, at: newWordPosition)
        data = WordListData(wordList: wordList, changedItemPosition: newWordPosition)
        cudOperations.add(wordItem)
            .subscribe()
            .disposed(by: disposeBag)
        requestTranslation(for: wordItem, newWordPosition)
    }

    private func remove(wordItem: WordItem) {
        if let position = data.wordList.firstIndex(where: { $0.id == wordItem.id }) {
            remove(at: position)
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
        var wordList = data.wordList

        guard position > -1 && position < wordList.count else { return }

        wordList[position] = updatedWordItem
        cudOperations.update(updatedWordItem)
            .subscribe()
            .disposed(by: disposeBag)
        data = WordListData(wordList: wordList, changedItemPosition: position)
    }

    private func subscribeToWordItemStream() {
        wordItemStream.newWordItem
            .subscribe(onNext: { [weak self] in self?.addNewWord($0) })
            .disposed(by: disposeBag)
        wordItemStream.removedWordItem
            .subscribe(onNext: { [weak self] in self?.remove(wordItem: $0) })
            .disposed(by: disposeBag)
    }
}
