//
//  CreateWordDbWorker.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

protocol CreateWordDbWorker {

    func create(word: Word) async throws
}

struct CreateWordDbWorkerImpl: CreateWordDbWorker {

    func create(word: Word) async throws {
        try await makeRealmCUD(operation: { (realm, word) in
            realm.add(WordDAO(word))
        }, with: word)
    }
}
