//
//  WordListViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import CoreModule
import RxSwift

/// An implementation of a word list view model.
final class WordListViewModelImpl<RouterType: ParametrizedRouter>: WordListViewModel
    where RouterType.Parameter == Word.Id {

    let wordList = BindableWordList(value: [])

    private let model: WordListModel
    private let updatedWordStream: UpdatedWordStream
    private let removedWordStream: RemovedWordStream
    private let router: RouterType
    private let logger: Logger

    private let disposeBag = DisposeBag()

    init(model: WordListModel, updatedWordStream: UpdatedWordStream, removedWordStream: RemovedWordStream,
         router: RouterType, logger: Logger) {
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
        model.remove(at: position, state: wordList.value)
            .subscribe(onSuccess: { state in
                self.onNewState(state, actionName: "REMOVE WORD AT #\(position)")
            })
            .disposed(by: disposeBag)
    }

    func toggleWordIsFavorite(at position: Int) {
        model.toggleIsFavorite(at: position, state: wordList.value)
            .subscribe(onSuccess: { state in
                self.onNewState(state, actionName: "TOGGLE WORD ISFAVORITE AT #\(position)")
            })
            .disposed(by: disposeBag)
    }

    private func onNewState(_ state: WordListState, actionName: String) {
        logger.logState(actionName: actionName, state)

        wordList.accept(state)
    }

    private func subscribe() {
        removedWordStream.removedWord
            .map {
                self.model.remove(word: $0, state: self.wordList.value)
            }
            .concat()
            .subscribe(onNext: { state in
                self.onNewState(state, actionName: "REMOVE WORD")
            })
            .disposed(by: disposeBag)
        updatedWordStream.updatedWord
            .map {
                self.model.update(word: $0, state: self.wordList.value)
            }
            .concat()
            .subscribe(onNext: { state in
                self.onNewState(state, actionName: "UPDATE WORD")
            })
            .disposed(by: disposeBag)
    }
}
