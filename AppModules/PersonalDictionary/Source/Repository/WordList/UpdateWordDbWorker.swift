//
//  UpdateWordDbWorker.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.05.2023.
//

protocol UpdateWordDbWorker {

    func update(word: Word) async throws
}

struct UpdateWordDbWorkerImpl: UpdateWordDbWorker {

    func update(word: Word) async throws {
        try await makeRealmCUD(operation: { (realm, word) in
            let wordDAO = try realm.findWordBy(id: word.id)

            wordDAO.update(from: word)
        }, with: word)
    }
}
