//
//  WordListViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import CoreModule
import Observation

/// An implementation of a word list view model.
@Observable
final class WordListViewModelImpl<RouterType: ParametrizedRouter>: WordListViewModel
    where RouterType.Parameter == Word.Id {

    var wordList: WordListState = []

    private let model: WordListModel
    private let updatedWordStream: UpdatedWordStream
    private let removedWordStream: RemovedWordStream
    private let router: RouterType
    private let logger: Logger

    private var tasks: [Task<Void, Never>] = []

    init(model: WordListModel, updatedWordStream: UpdatedWordStream, removedWordStream: RemovedWordStream,
         router: RouterType, logger: Logger) {
        self.model = model
        self.updatedWordStream = updatedWordStream
        self.removedWordStream = removedWordStream
        self.router = router
        self.logger = logger
        subscribe()
    }

    deinit {
        tasks.forEach { $0.cancel() }
    }

    func select(at position: Int) {
        guard let word = wordList[safeIndex: position] else { return }

        router.navigate(word.id)
    }

    func remove(at position: Int) {
        tasks.append(
            Task { [weak self] in
                guard let self else { return }

                do {
                    let state = try await model.remove(at: position, state: wordList)

                    onNewState(state, actionName: "REMOVE WORD AT #\(position)")
                } catch {
                    logger.errorWithContext(error)
                }
            }
        )
    }

    func toggleWordIsFavorite(at position: Int) {
        tasks.append(
            Task { [weak self] in
                guard let self else { return }

                do {
                    let state = try await model.toggleIsFavorite(at: position, state: wordList)

                    onNewState(state, actionName: "TOGGLE WORD ISFAVORITE AT #\(position)")
                } catch {
                    logger.errorWithContext(error)
                }
            }
        )
    }

    private func onNewState(_ state: WordListState, actionName: String) {
        logger.logState(actionName: actionName, state)

        wordList = state
    }

    private func subscribe() {
        tasks.append(
            Task { [weak self] in
                guard let self else { return }

                for await word in removedWordStream.removedWord {
                    do {
                        let state = try await model.remove(word: word, state: wordList)

                        onNewState(state, actionName: "REMOVE WORD")
                    } catch {
                        logger.errorWithContext(error)
                    }
                }
            }
        )
        tasks.append(
            Task { [weak self] in
                guard let self else { return }

                for await updatedWord in updatedWordStream.updatedWord {
                    do {
                        let state = try await model.update(word: updatedWord, state: wordList)

                        onNewState(state, actionName: "UPDATE WORD")
                    } catch {
                        logger.errorWithContext(error)
                    }
                }
            }
        )
    }
}
