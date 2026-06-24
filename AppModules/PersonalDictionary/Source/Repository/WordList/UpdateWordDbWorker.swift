//
//  UpdateWordDbWorker.swift
//  
//
//  Created by Maksim Ivanov on 10.05.2023.
//

import CoreModule

protocol UpdateWordDbWorker {

    /// Update a word in the personal dictionary storage.
    /// - Parameters:
    ///  - word: the updated word.
    /// - Returns: the updated word.
    func update(word: Word) async throws -> Word
}

struct RealmUpdateWordDbWorker: UpdateWordDbWorker {

    func update(word: Word) async throws -> Word {
        try await makeRealmCUD(operation: { (realm, word) in
            let wordDAO = try realm.findWordBy(id: word.id)

            wordDAO.update(from: word)
        }, with: word)
    }
}

struct UpdateWordDbWorkerLog: UpdateWordDbWorker {

    let updateWordDbWorker: UpdateWordDbWorker
    let logger: Logger

    func update(word: Word) async throws -> Word {
        logger.log("UPDATE WORD IN LOCAL STORAGE START\nWORD = \(word)", level: .info)

        do {
            let result = try await updateWordDbWorker.update(word: word)

            logger.log("UPDATE WORD IN LOCAL STORAGE SUCCESS\nWORD = \(result)", level: .info)

            return result
        } catch {
            logger.log("UPDATE WORD IN LOCAL STORAGE ERROR\nerror = \(error)", level: .error)
            throw error
        }
    }
}
