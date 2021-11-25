//
//  WordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxSwift

final class WordListModelImpl: WordListModel {

    private let viewModelBlock: () -> WordListViewModel?
    private lazy var viewModel: WordListViewModel? = viewModelBlock()

    private let cudOperations: WordItemCUDOperations
    private let wordItemStream: ReadableWordItemStream & RemovedWordItemStream
    private let translationService: TranslationService
    private let logger: Logger

    private let disposeBag = DisposeBag()

    var data: WordListData = WordListData(wordList: [], changedItemPosition: nil) {
        didSet {
            viewModel?.wordListData = data
        }
    }

    init(viewModelBlock: @escaping () -> WordListViewModel?,
         cudOperations: WordItemCUDOperations,
         translationService: TranslationService,
         wordItemStream: ReadableWordItemStream & RemovedWordItemStream,
         logger: Logger) {
        self.viewModelBlock = viewModelBlock
        self.cudOperations = cudOperations
        self.translationService = translationService
        self.wordItemStream = wordItemStream
        self.logger = logger
        subscribeToWordItemStream()
    }

    func remove(_ wordItem: WordItem, at position: Int) {
        var wordList = data.wordList

        wordList.remove(at: position)
        data = WordListData(wordList: wordList, changedItemPosition: position)
        cudOperations.remove(with: wordItem.id)
            .subscribe()
            .disposed(by: disposeBag)
    }

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

    func sendRemovedWordItem(_ wordItem: WordItem) {
        wordItemStream.sendRemovedWordItem(wordItem)
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
            remove(wordItem, at: position)
        }
    }

    private func requestTranslation(for wordItem: WordItem, _ position: Int) {
        translationService.fetchTranslation(for: wordItem)
            .subscribe(onSuccess: { [weak self] translation in
                self?.update(wordItem: wordItem, with: translation, at: position)
            }, onError: { [weak self] error in
                self?.logger.log(error: error)
            }).disposed(by: disposeBag)
    }

    private func update(wordItem: WordItem, with translation: String, at position: Int) {
        let updatedWordItem = wordItem.update(translation: translation)
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
            .subscribe(onNext: { self.addNewWord($0) })
            .disposed(by: disposeBag)
        wordItemStream.removedWordItem
            .subscribe(onNext: { self.remove(wordItem: $0) })
            .disposed(by: disposeBag)
    }
}
