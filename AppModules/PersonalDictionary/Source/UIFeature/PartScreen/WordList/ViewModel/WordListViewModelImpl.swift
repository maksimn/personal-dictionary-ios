//
//  WordListViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import CoreModule
import RxSwift

/// Реализация модели представления списка слов.
final class WordListViewModelImpl: WordListViewModel {

    let wordList = BindableWordList(value: [])

    private let model: WordListModel
    private let wordStream: ReadableWordStream
    private let logger: SLogger
    private let disposeBag = DisposeBag()

    init(model: WordListModel, wordStream: ReadableWordStream, logger: SLogger) {
        self.model = model
        self.wordStream = wordStream
        self.logger = logger
        subscribe()
    }

    func remove(at position: Int) {
        remove(at: position, withSideEffect: true)
    }

    func toggleWordIsFavorite(at position: Int) {
        guard position > -1 && position < wordList.value.count else { return }
        var word = wordList.value[position]

        word.isFavorite.toggle()
        update(word, at: position, withSideEffect: true)
    }

    func fetchTranslationsIfNeeded(start: Int, end: Int) -> Completable {
        model.fetchTranslationsFor(state: wordList.value, start: start, end: end)
            .executeInBackgroundAndObserveOnMainThread()
            .map { [weak self] state in
                self?.onNewState(state, actionName: "fetchTranslationsIfNeeded")
                return state
            }
            .asCompletable()
    }

    private func onNewState(_ state: WordListState, actionName: String) {
        logState(actionName: actionName, state)

        wordList.accept(state)
    }

    private func create(_ word: Word) {
        let wordList = model.create(word, state: self.wordList.value)

        onNewState(wordList, actionName: "create word")

        model.createEffect(word, state: wordList)
            .executeInBackgroundAndObserveOnMainThread()
            .subscribe(
                onSuccess: { [weak self] wordList in
                    self?.onNewState(wordList, actionName: "create effect")
                },
                onError: { [weak self] error in
                    self?.logger.logError(error, source: "create word effect")
                }
            ).disposed(by: disposeBag)
    }

    private func update(_ word: Word, at position: Int, withSideEffect: Bool) {
        let wordList = model.update(word, at: position, state: self.wordList.value)

        onNewState(wordList, actionName: "update word")

        guard withSideEffect else { return }

        model.updateEffect(word, state: wordList)
            .executeInBackgroundAndObserveOnMainThread()
            .subscribe(
                onError: { [weak self] error in
                    self?.logger.logError(error, source: "update word effect")
                }
            ).disposed(by: disposeBag)
    }

    private func remove(at position: Int, withSideEffect: Bool) {
        guard position > -1 && position < wordList.value.count else { return }
        let word = wordList.value[position]
        let wordList = model.remove(at: position, state: self.wordList.value)

        onNewState(wordList, actionName: "remove word")

        guard withSideEffect else { return }

        model.removeEffect(word, state: wordList)
            .executeInBackgroundAndObserveOnMainThread()
            .subscribe(
                onError: { [weak self] error in
                    self?.logger.logError(error, source: "remove word effect")
                }
            ).disposed(by: disposeBag)
    }

    private func findAndRemove(_ word: Word) {
        guard let position = wordList.value.firstIndex(where: { $0.id == word.id }) else { return }

        remove(at: position, withSideEffect: false)
    }

    private func findAndUpdate(_ word: Word) {
        guard let position = wordList.value.firstIndex(where: { $0.id == word.id }) else { return }

        update(word, at: position, withSideEffect: false)
    }

    private func subscribe() {
        wordStream.newWord
            .subscribe(onNext: { [weak self] in
                self?.log($0, fromModelStream: "new word")

                self?.create($0)
            })
            .disposed(by: disposeBag)
        wordStream.removedWord
            .subscribe(onNext: { [weak self] in
                self?.log($0, fromModelStream: "removed word")

                self?.findAndRemove($0)
            })
            .disposed(by: disposeBag)
        wordStream.updatedWord
            .subscribe(onNext: { [weak self] in
                self?.log($0, fromModelStream: "updated word")

                self?.findAndUpdate($0)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Logging

    private func logState(actionName: String, _ state: WordListState) {
        logger.log("Word list \(actionName) result:")

        if wordList.value == state {
            logger.log("\t\tno state changes")
        } else {
            logger.log("\t\tWord list state: \(state)")
        }
    }

    private func log(_ word: Word, fromModelStream modelStreamName: String) {
        logger.log("Received word = \(word) from the \(modelStreamName) model stream.")
    }
}
