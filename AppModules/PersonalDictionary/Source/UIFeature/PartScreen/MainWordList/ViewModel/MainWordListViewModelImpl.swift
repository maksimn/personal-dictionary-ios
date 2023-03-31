//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import CoreModule
import RxSwift

final class MainWordListViewModelImpl: MainWordListViewModel {

    let wordList = BindableWordList(value: [])

    private let model: MainWordListModel
    private let newWordStream: NewWordStream
    private let logger: Logger

    private let disposeBag = DisposeBag()

    init(model: MainWordListModel, newWordStream: NewWordStream, logger: Logger) {
        self.model = model
        self.newWordStream = newWordStream
        self.logger = logger
        subscribe()
    }

    func fetch() {
        let wordList = model.fetchMainWordList()

        onNewState(wordList, actionName: "FETCH MAIN WORDLIST")
    }

    private func onNewState(_ state: WordListState, actionName: String) {
        logger.logState(actionName: actionName, state)

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
                onFailure: { [weak self] error in
                    self?.logger.errorWithContext(error)
                }
            ).disposed(by: disposeBag)
    }

    private func subscribe() {
        newWordStream.newWord
            .subscribe(onNext: { [weak self] word in
                self?.logger.logReceiving(word, fromModelStream: "new word")

                self?.create(word)
            })
            .disposed(by: disposeBag)
    }
}
