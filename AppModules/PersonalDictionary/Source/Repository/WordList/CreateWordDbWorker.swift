//
//  CreateWordDbWorker.swift
//  
//
//  Created by Maksim Ivanov on 10.05.2023.
//

import CoreModule

protocol CreateWordDbWorker {

    /// Add a word to the personal dictionary storage.
    /// - Parameters:
    ///  - word: the word to add.
    /// - Returns: the word after the addition operation.
    func create(word: Word) async throws -> Word
}

struct RealmCreateWordDbWorker: CreateWordDbWorker {

    func create(word: Word) async throws -> Word {
        try await makeRealmCUD(operation: { (realm, word) in
            realm.add(WordDAO(word))
        }, with: word)
    }
}

struct CreateWordDbWorkerLog: CreateWordDbWorker {

    let createWordDbWorker: CreateWordDbWorker
    let logger: Logger

    func create(word: Word) async throws -> Word {
        logger.log("CREATE WORD IN LOCAL STORAGE START\nWORD = \(word)", level: .info)

        do {
            let result = try await createWordDbWorker.create(word: word)

            logger.log("CREATE WORD IN LOCAL STORAGE SUCCESS\nWORD = \(result)", level: .info)

            return result
        } catch {
            logger.log("CREATE WORD IN LOCAL STORAGE ERROR\nerror = \(error)", level: .error)
            throw error
        }
    }
}
