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

    private let cudOperations: WordCUDOperations
    private let wordStream: WordStream
    private let translationService: TranslationService

    private let disposeBag = DisposeBag()

    /// Стейт модели списка слов.
    var wordList: [Word] = [] {
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
    ///  - wordStream: ModelStream для событий со словами в личном словаре.
    init(viewModelBlock: @escaping () -> WordListViewModel?,
         cudOperations: WordCUDOperations,
         translationService: TranslationService,
         wordStream: WordStream) {
        self.viewModelBlock = viewModelBlock
        self.cudOperations = cudOperations
        self.translationService = translationService
        self.wordStream = wordStream
        subscribeToWordStream()
    }

    /// Удалить слово по заданному индексу из списка
    /// - Parameters:
    ///  - position: позиция (индекс) слова в списке.
    func remove(at position: Int) {
        let removedWord = removeInMemory(at: position)

        cudOperations.remove(with: removedWord.id).subscribe().disposed(by: disposeBag)
        wordStream.sendRemovedWord(removedWord)
    }

    /// Переключить значение флага "избранности" (isFavorite) для слова по заданному индексу из списка
    /// - Parameters:
    ///  - position: позиция (индекс) слова в списке.
    func toggleWordIsFavorite(at position: Int) {
        let updatedWord = toggleWordIsFavoriteInMemory(at: position)

        cudOperations.update(updatedWord).subscribe().disposed(by: disposeBag)
        wordStream.sendUpdatedWord(updatedWord)
    }

    /// Запросить перевод для слов в списке, расположенных в заданном интервале индексов.
    /// - Parameters:
    ///  - startPosition: позиция (индекс) начального слова.
    ///  - endPosition: верхняя граница индексов слов для перевода (не включая).
    func requestTranslationsIfNeededWithin(startPosition: Int, endPosition: Int) {
        guard endPosition > startPosition, startPosition > -1 else { return }
        let endPosition = min(wordList.count, endPosition)
        var notTranslatedWords = [(word: Word, position: Int)]()

        for position in startPosition..<endPosition where wordList[position].translation == nil {
            notTranslatedWords.append((word: wordList[position], position: position))
        }

        guard notTranslatedWords.count > 0 else { return }

        Observable.from(notTranslatedWords)
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

    private func removeInMemory(at position: Int) -> Word {
        let word = wordList[position]

        wordList.remove(at: position)

        return word
    }

    private func toggleWordIsFavoriteInMemory(at position: Int) -> Word {
        var word = wordList[position]

        word.isFavorite = !word.isFavorite
        wordList[position] = word

        return word
    }

    private func addNewWord(_ word: Word) {
        let newWordPosition = 0

        wordList.insert(word, at: newWordPosition)
        cudOperations.add(word)
            .subscribe()
            .disposed(by: disposeBag)
        requestTranslation(for: word, newWordPosition)
    }

    private func remove(word: Word) {
        if let position = wordList.firstIndex(where: { $0.id == word.id }) {
            _ = removeInMemory(at: position)
        }
    }

    private func requestTranslation(for word: Word, _ position: Int) {
        translationService.fetchTranslation(for: word)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] translation in
                self?.update(word: word, with: translation, at: position)
            }, onError: { _ in

            }).disposed(by: disposeBag)
    }

    private func update(word: Word, with translation: String, at position: Int) {
        var updatedWord = word

        updatedWord.translation = translation

        guard position > -1 && position < wordList.count else { return }

        wordList[position] = updatedWord
        cudOperations.update(updatedWord)
            .subscribe()
            .disposed(by: disposeBag)
    }

    private func updateInMemory(updatedWord: Word) {
        if let position = wordList.firstIndex(where: { $0.id == updatedWord.id }) {
            wordList[position] = updatedWord
        }
    }

    private func subscribeToWordStream() {
        wordStream.newWord
            .subscribe(onNext: { [weak self] in self?.addNewWord($0) })
            .disposed(by: disposeBag)
        wordStream.removedWord
            .subscribe(onNext: { [weak self] in self?.remove(word: $0) })
            .disposed(by: disposeBag)
        wordStream.updatedWord
            .subscribe(onNext: { [weak self] in self?.updateInMemory(updatedWord: $0) })
            .disposed(by: disposeBag)
    }
}
