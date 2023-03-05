//
//  WordListViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxSwift

/// Реализация модели представления списка слов.
final class WordListViewModelImpl: WordListViewModel {

    let wordList = BindableWordList(value: [])

    private let model: WordListModel
    private let wordStream: ReadableWordStream
    private let disposeBag = DisposeBag()

    private enum Operation { case add, update, toggleIsFavorite, remove }

    init(model: WordListModel, wordStream: ReadableWordStream) {
        self.model = model
        self.wordStream = wordStream
        subscribe()
    }

    func remove(at position: Int) {
        perform(.remove, at: position)
    }

    func toggleWordIsFavorite(at position: Int) {
        perform(.toggleIsFavorite, at: position)
    }

    func fetchTranslationsIfNeededWithin(start: Int, end: Int) {
        let wordList = self.wordList.value
        guard end > start, start > -1 else { return }
        let end = min(wordList.count, end)
        var notTranslated: [Word] = []

        for position in start..<end where wordList[position].translation == nil {
            notTranslated.append(wordList[position])
        }

        model.fetchTranslationsFor(notTranslated)
            .subscribe(onNext: { [weak self] word in
                self?.onUpdatedWord(word, withSideEffect: true)
            }).disposed(by: disposeBag)
    }

    private func perform(_ operation: Operation, at position: Int, updated: Word? = nil, withSideEffect: Bool = true) {
        var wordList = self.wordList.value
        guard position > -1 && position < wordList.count else { return }
        var word = wordList[position]

        switch operation {
        case .add:
            if let word = updated {
                wordList.insert(word, at: position)
                guard withSideEffect else { break }
                model.create(word)
                    .subscribe().disposed(by: disposeBag)
            }
        case .remove:
            wordList.remove(at: position)
            guard withSideEffect else { break }
            model.remove(word)
                .subscribe().disposed(by: disposeBag)

        case .toggleIsFavorite:
            word.isFavorite.toggle()
            wordList[position] = word
            guard withSideEffect else { break }
            model.update(word)
                .subscribe().disposed(by: disposeBag)

        case .update:
            if let updated = updated {
                wordList[position] = updated
                guard withSideEffect else { break }
                model.update(updated)
                    .subscribe().disposed(by: disposeBag)
            }
        }

        self.wordList.accept(wordList)
    }

    private func subscribe() {
        wordStream.newWord
            .subscribe(onNext: { [weak self] in self?.perform(.add, at: 0, updated: $0) })
            .disposed(by: disposeBag)
        wordStream.removedWord
            .subscribe(onNext: { [weak self] in self?.onRemovedWord($0) })
            .disposed(by: disposeBag)
        wordStream.updatedWord
            .subscribe(onNext: { [weak self] in self?.onUpdatedWord($0, withSideEffect: false) })
            .disposed(by: disposeBag)
    }

    private func onRemovedWord(_ word: Word) {
        guard let position = wordList.value.firstIndex(where: { $0.id == word.id }) else { return }

        perform(.remove, at: position, withSideEffect: false)
    }

    private func onUpdatedWord(_ word: Word, withSideEffect: Bool) {
        guard let position = wordList.value.firstIndex(where: { $0.id == word.id }) else { return }

        perform(.update, at: position, updated: word, withSideEffect: withSideEffect)
    }
}
