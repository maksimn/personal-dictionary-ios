//
//  WordListViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import CoreModule
import RxSwift

// Problem: too many logic in the view model. Need to refactor.

/// Реализация модели представления списка слов.
final class WordListViewModelImpl<RouterType: ParametrizedRouter>: WordListViewModel
    where RouterType.Parameter == Word.Id {

    let wordList = BindableWordList(value: [])

    private let model: WordListModel
    private let updatedWordStream: UpdatedWordStream
    private let removedWordStream: RemovedWordStream
    private let router: RouterType
    private let logger: Logger

    private let disposeBag = DisposeBag()

    init(
        model: WordListModel,
        updatedWordStream: UpdatedWordStream,
        removedWordStream: RemovedWordStream,
        router: RouterType,
        logger: Logger
    ) {
        self.model = model
        self.updatedWordStream = updatedWordStream
        self.removedWordStream = removedWordStream
        self.router = router
        self.logger = logger
        subscribe()
    }

    func select(at position: Int) {
        guard let word = wordList.value[safeIndex: position] else { return }

        router.navigate(word.id)
    }

    func remove(at position: Int) {
        remove(at: position, withSideEffect: true)
    }

    func toggleWordIsFavorite(at position: Int) {
        guard position > -1 && position < wordList.value.count else { return }
        var word = wordList.value[position]
        let wordOldValue = word

        word.isFavorite.toggle()
        update(UpdatedWord(newValue: word, oldValue: wordOldValue), at: position, withSideEffect: true)
    }

    private func onNewState(_ state: WordListState, actionName: String) {
        logger.logState(actionName: actionName, state)

        wordList.accept(state)
    }

    private func update(_ updatedWord: UpdatedWord, at position: Int, withSideEffect: Bool) {
        let wordList = model.update(updatedWord.newValue, at: position, state: self.wordList.value)

        onNewState(wordList, actionName: "update word")

        guard withSideEffect else { return }

        model.updateEffect(updatedWord, state: wordList)
            .executeInBackgroundAndObserveOnMainThread()
            .subscribe()
            .disposed(by: disposeBag)
    }

    private func remove(at position: Int, withSideEffect: Bool) {
        guard position > -1 && position < wordList.value.count else { return }
        let word = wordList.value[position]
        let wordList = model.remove(at: position, state: self.wordList.value)

        onNewState(wordList, actionName: "remove word")

        guard withSideEffect else { return }

        model.removeEffect(word, state: wordList)
            .executeInBackgroundAndObserveOnMainThread()
            .subscribe()
            .disposed(by: disposeBag)
    }

    private func findAndRemove(_ word: Word) {
        guard let position = wordList.value.firstIndex(where: { $0.id == word.id }) else { return }

        remove(at: position, withSideEffect: false)
    }

    private func findAndUpdate(_ updatedWord: UpdatedWord) {
        guard let position = wordList.value.firstIndex(where: { $0.id == updatedWord.newValue.id }) else { return }

        update(updatedWord, at: position, withSideEffect: false)
    }

    private func subscribe() {
        removedWordStream.removedWord
            .subscribe(onNext: { [weak self] word in
                self?.findAndRemove(word)
            })
            .disposed(by: disposeBag)
        updatedWordStream.updatedWord
            .subscribe(onNext: { [weak self] updatedWord in
                self?.findAndUpdate(updatedWord)
            })
            .disposed(by: disposeBag)
    }
}
