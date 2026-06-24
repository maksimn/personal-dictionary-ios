//
//  WordListModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

/// Word list model.
protocol WordListModel {

    func remove(at position: Int, state: WordListState) async throws -> WordListState

    func remove(word: Word, state: WordListState) async throws -> WordListState

    func toggleIsFavorite(at position: Int, state: WordListState) async throws -> WordListState

    func update(word: UpdatedWord, state: WordListState) async throws -> WordListState
}
