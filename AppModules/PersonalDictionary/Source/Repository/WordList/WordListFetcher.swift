//
//  WordListRepository.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import RealmSwift

protocol WordListFetcher {

    func wordList() throws -> [Word]
}

struct WordListFetcherImpl: WordListFetcher {

    func wordList() throws -> [Word] {
        try Realm().objects(WordDAO.self)
            .sorted(byKeyPath: "createdAt", ascending: false)
            .compactMap { Word($0) }
    }
}
