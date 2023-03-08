//
//  WordListModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxSwift

/// Модель списка слов.
protocol WordListModel {

    func create(_ word: Word, state: WordListState) -> WordListState

    func createEffect(_ word: Word, state: WordListState) -> Single<WordListState>

    func remove(at position: Int, state: WordListState) -> WordListState

    func removeEffect(_ word: Word, state: WordListState) -> Single<WordListState>

    func update(_ word: Word, at position: Int, state: WordListState) -> WordListState

    func updateEffect(_ word: Word, state: WordListState) -> Single<WordListState>

    func fetchTranslationsFor(state: WordListState, start: Int, end: Int) -> Single<WordListState>
}
