//
//  DeleteWordDbWorker.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

protocol DeleteWordDbWorker {

    func delete(wordId: Word.Id) async throws -> Word.Id
}

struct DeleteWordDbWorkerImpl: DeleteWordDbWorker {

    func delete(wordId: Word.Id) async throws -> Word.Id {
        try await makeRealmCUD(operation: { (realm, word) in
            let wordDAO = try realm.findWordBy(id: wordId)

            realm.delete(wordDAO)
        }, with: Word())

        return wordId
    }
}
