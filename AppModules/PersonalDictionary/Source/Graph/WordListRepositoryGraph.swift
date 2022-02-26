//
//  WordListRepositoryGraph.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 27.02.2022.
//

/// DI контейнер хранилища списка слов.
protocol WordListRepositoryGraph {

    /// Хранилище списка слов.
    var repository: WordListRepository { get }
}
