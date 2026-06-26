//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import CoreModule
import Observation

@Observable
final class MainWordListViewModelImpl: MainWordListViewModel {

    private(set) var wordList: WordListState = []

    private let model: MainWordListModel
    private let newWordStream: NewWordStream
    private let logger: Logger

    private var tasks: [Task<Void, Never>] = []

    init(model: MainWordListModel, newWordStream: NewWordStream, logger: Logger) {
        self.model = model
        self.newWordStream = newWordStream
        self.logger = logger
        subscribe()
    }

    deinit {
        tasks.forEach { $0.cancel() }
    }

    func fetch() {
        let wordList = model.fetchMainWordList()

        onNewState(wordList, actionName: "FETCH MAIN WORDLIST")
    }

    // Issue: Lack of testing of this private logic.
    private func onNewState(_ state: WordListState, actionName: String) {
        logger.logState(actionName: actionName, state)

        wordList = state
    }

    private func create(_ word: Word) {
        let wordList = model.create(word, state: model.fetchMainWordList())

        onNewState(wordList, actionName: "create word")

        tasks.append(
            Task { [weak self] in
                guard let self else { return }

                do {
                    let wordList = try await self.model.createEffect(word, state: wordList)

                    onNewState(wordList, actionName: "create effect")
                } catch {
                    logger.errorWithContext(error)
                }
            }
        )
    }

    private func subscribe() {
        tasks.append(
            Task { [weak self] in
                guard let self else { return }

                for await word in newWordStream.newWord {
                    create(word)
                }
            }
        )
    }
}
