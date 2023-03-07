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

    private enum Operation { case add, update, remove }

    init(model: WordListModel, wordStream: ReadableWordStream) {
        self.model = model
        self.wordStream = wordStream
        subscribe()
    }

    func remove(at position: Int) {
        perform(.remove, at: position)
    }

    func toggleWordIsFavorite(at position: Int) {
        guard position > -1 && position < wordList.value.count else { return }
        var word = wordList.value[position]

        word.isFavorite.toggle()
        perform(.update, at: position, updated: word)
    }

    func fetchTranslationsIfNeededWithin(start: Int, end: Int) {
        model.fetchTranslationsFor(wordList.value, start: start, end: end)
            .subscribe(onNext: { [weak self] (translated: Word) in
                self?.onUpdatedWord(translated, withSideEffect: false)
            })
            .disposed(by: disposeBag)
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

    private func perform(_ operation: Operation, at position: Int, updated: Word? = nil, withSideEffect: Bool = true) {
        var wordList = self.wordList.value
        guard position > -1 && position < wordList.count else { return }
        let word = wordList[position]

        switch operation {
        case .add:
            if let word = updated {
                wordList.insert(word, at: position)

                guard withSideEffect else { break }

                model.create(word)
                    .subscribe(onSuccess: { [weak self] word in
                        self?.onUpdatedWord(word, withSideEffect: false)
                    }).disposed(by: disposeBag)
            }
        case .remove:
            wordList.remove(at: position)
            guard withSideEffect else { break }
            model.remove(word)
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

    private func onRemovedWord(_ word: Word) {
        guard let position = wordList.value.firstIndex(where: { $0.id == word.id }) else { return }

        perform(.remove, at: position, withSideEffect: false)
    }

    private func onUpdatedWord(_ word: Word, withSideEffect: Bool) {
        guard let position = wordList.value.firstIndex(where: { $0.id == word.id }) else { return }

        perform(.update, at: position, updated: word, withSideEffect: withSideEffect)
    }
}
