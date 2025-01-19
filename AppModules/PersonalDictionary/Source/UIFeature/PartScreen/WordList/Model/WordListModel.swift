//
//  WordListModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxSwift

/// Модель списка слов.
protocol WordListModel {

    func remove(at position: Int, state: WordListState) -> Single<WordListState>

    func remove(word: Word, state: WordListState) -> Single<WordListState>

    func toggleIsFavorite(at position: Int, state: WordListState) -> Single<WordListState>

    func update(word: UpdatedWord, state: WordListState) -> Single<WordListState>
}
